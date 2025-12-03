import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/chat/chat_bloc.dart';
import '../../blocs/live_event/live_event_bloc.dart';
import '../../blocs/cart_bloc.dart';
import '../../blocs/auth_bloc.dart';
import '../../models/chat_message.dart';
import '../../services/mock_api_service.dart';
import '../../services/mock_socket_service.dart';
import '../../services/socket_io_service.dart';

class LiveEventScreen extends StatefulWidget {
  final String eventId;

  const LiveEventScreen({super.key, required this.eventId});

  @override
  State<LiveEventScreen> createState() => _LiveEventScreenState();
}

class _LiveEventScreenState extends State<LiveEventScreen> {
  late final VideoPlayerController _videoController;
  double _volume = 0.7;
  bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
    _videoController =
        VideoPlayerController.networkUrl(
            Uri.parse(
              'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
            ),
          )
          ..setVolume(_volume)
          ..initialize().then((_) {
            setState(() {
              _isVideoInitialized = true;
            });
          });
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final api = MockApiService();
    final mockSocket = MockSocketService();
    final ioSocket = SocketIoService();

    return MultiBlocProvider(
      providers: [
        BlocProvider<LiveEventBloc>(
          create: (_) =>
              LiveEventBloc(api: api, socket: mockSocket)
                ..add(LiveEventOpened(widget.eventId)),
        ),
        BlocProvider<ChatBloc>(
          create: (_) =>
              ChatBloc(socket: ioSocket)..add(ChatStarted(widget.eventId)),
        ),
      ],
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          final isLoggedIn =
              authState.status == AuthStatus.authenticated &&
              authState.user != null;
          final currentUser = authState.user;

          return Scaffold(
            appBar: AppBar(
              title: const Text('Live Event'),
              actions: [
                IconButton(
                  icon: Icon(
                    Theme.of(context).brightness == Brightness.dark
                        ? Icons.light_mode
                        : Icons.dark_mode,
                  ),
                  onPressed: () {
                    final messenger = ScaffoldMessenger.of(context);
                    messenger.showSnackBar(
                      const SnackBar(
                        content: Text('Use home toggle to change theme'),
                      ),
                    );
                  },
                ),
              ],
            ),
            body: SafeArea(
              child: Stack(
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isSmall = constraints.maxWidth < 900;
                      final content = [
                        Expanded(
                          flex: 2,
                          child: _LiveVideoAndProducts(
                            controller: _videoController,
                            isInitialized: _isVideoInitialized,
                            volume: _volume,
                            onTogglePlay: () {
                              setState(() {
                                if (_videoController.value.isPlaying) {
                                  _videoController.pause();
                                } else {
                                  _videoController.play();
                                }
                              });
                            },
                            onVolumeChanged: (v) {
                              setState(() {
                                _volume = v;
                                _videoController.setVolume(v);
                              });
                            },
                          ),
                        ),
                        const VerticalDivider(width: 1),
                        Expanded(
                          flex: 1,
                          child: _LiveChatPanel(
                            currentUserId: currentUser?.id ?? '',
                            currentUserName: currentUser?.name ?? 'Guest',
                            roomId: widget.eventId,
                          ),
                        ),
                      ];

                      if (isSmall) {
                        return Column(
                          children: [
                            Expanded(child: content[0]),
                            const Divider(height: 1),
                            Expanded(child: content[2]),
                          ],
                        );
                      }

                      return Row(children: content);
                    },
                  ),
                  if (!isLoggedIn)
                    Positioned.fill(
                      child: Container(color: Colors.black.withAlpha(60)),
                    ),
                  if (!isLoggedIn)
                    Positioned.fill(
                      child: Container(
                        color: Colors.black.withOpacity(0.6),
                        child: Center(
                          child: Card(
                            margin: const EdgeInsets.all(24),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    'Please log in to watch and chat in this live stream',
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 12),
                                  ElevatedButton(
                                    onPressed: () {
                                      context.pushNamed('login');
                                    },
                                    child: const Text('Go to login'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _LiveVideoAndProducts extends StatelessWidget {
  final VideoPlayerController controller;
  final bool isInitialized;
  final double volume;
  final VoidCallback onTogglePlay;
  final ValueChanged<double> onVolumeChanged;

  const _LiveVideoAndProducts({
    required this.controller,
    required this.isInitialized,
    required this.volume,
    required this.onTogglePlay,
    required this.onVolumeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LiveEventBloc, LiveEventState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.error != null) {
          return Center(child: Text('Error: ${state.error}'));
        }
        final event = state.liveEvent;
        if (event == null) {
          return const Center(child: Text('Event not found'));
        }
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Container(
                      color: Colors.black,
                      child: isInitialized
                          ? VideoPlayer(controller)
                          : const Center(child: CircularProgressIndicator()),
                    ),
                    if (isInitialized)
                      _VideoControlsOverlay(
                        controller: controller,
                        isPlaying: controller.value.isPlaying,
                        volume: volume,
                        onTogglePlay: onTogglePlay,
                        onVolumeChanged: onVolumeChanged,
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        event.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Text(
                        'LIVE',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Icon(Icons.remove_red_eye, size: 16),
                    const SizedBox(width: 4),
                    Text('${state.viewerCount}'),
                  ],
                ),
              ),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(12),
                itemBuilder: (context, index) {
                  final product = event.products[index];
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    leading: SizedBox(
                      width: 56,
                      height: 56,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          product.thumbnail,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    title: Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(product.currentPrice.toStringAsFixed(2)),
                    trailing: IconButton(
                      icon: const Icon(Icons.add_shopping_cart),
                      onPressed: () {
                        final cartBloc = context.read<CartBloc>();
                        cartBloc.add(
                          CartItemAdded(productId: product.id, quantity: 1),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Added ${product.name} to cart'),
                          ),
                        );
                      },
                    ),
                  );
                },
                separatorBuilder: (context, index) => const Divider(),
                itemCount: event.products.length,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _LiveChatPanel extends StatelessWidget {
  final String currentUserId;
  final String currentUserName;
  final String roomId;

  const _LiveChatPanel({
    required this.currentUserId,
    required this.currentUserName,
    required this.roomId,
  });

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();

    return Column(
      children: [
        Expanded(
          child: BlocBuilder<ChatBloc, ChatState>(
            builder: (context, state) {
              return Container(
                color: Theme.of(context).colorScheme.surface,
                child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: state.messages.length,
                  itemBuilder: (context, index) {
                    final message = state.messages[index];
                    final isMe = message.senderId == currentUserId;
                    return _ChatMessageTile(message: message, isMe: isMe);
                  },
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    hintText: 'Send a message...',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {
                  final text = controller.text.trim();
                  if (text.isEmpty) return;
                  context.read<ChatBloc>().add(
                    ChatMessageSent(
                      message: text,
                      senderId: currentUserId,
                      senderName: currentUserName,
                      roomId: roomId,
                    ),
                  );
                  controller.clear();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ChatMessageTile extends StatelessWidget {
  final ChatMessage message;
  final bool isMe;

  const _ChatMessageTile({required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isMe
              ? Theme.of(context).colorScheme.primaryContainer
              : Theme.of(context).colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: isMe
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Text(
              message.senderName,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              message.message,
              style: TextStyle(
                color: isMe
                    ? Theme.of(context).colorScheme.onPrimaryContainer
                    : Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VideoControlsOverlay extends StatelessWidget {
  final VideoPlayerController controller;
  final bool isPlaying;
  final double volume;
  final VoidCallback onTogglePlay;
  final ValueChanged<double> onVolumeChanged;

  const _VideoControlsOverlay({
    required this.controller,
    required this.isPlaying,
    required this.volume,
    required this.onTogglePlay,
    required this.onVolumeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Colors.black54, Colors.transparent],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(
                  isPlaying
                      ? Icons.pause_circle_filled
                      : Icons.play_circle_filled,
                  color: Colors.white,
                  size: 36,
                ),
                onPressed: onTogglePlay,
              ),
              const SizedBox(width: 8),
              const Icon(Icons.volume_up, color: Colors.white, size: 20),
              Expanded(
                child: Slider(
                  value: volume,
                  onChanged: onVolumeChanged,
                  min: 0,
                  max: 1,
                  activeColor: Colors.white,
                  inactiveColor: Colors.white30,
                ),
              ),
            ],
          ),
          VideoProgressIndicator(
            controller,
            allowScrubbing: true,
            colors: VideoProgressColors(
              playedColor: Colors.redAccent,
              bufferedColor: Colors.white54,
              backgroundColor: Colors.white24,
            ),
          ),
        ],
      ),
    );
  }
}
