import 'dart:async';
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
            backgroundColor: const Color(0xFF0F1729),
            body: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF0F1729),
                    Color(0xFF1A1D2E),
                    Color(0xFF2D1B4E),
                  ],
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    // Top Navigation Bar
                    _TopNavigationBar(
                      currentUser: currentUser,
                      isLoggedIn: isLoggedIn,
                    ),
                    
                    // Main Content
                    Expanded(
                      child: Stack(
                        children: [
                          LayoutBuilder(
                            builder: (context, constraints) {
                              final isSmall = constraints.maxWidth < 900;
                              
                              if (isSmall) {
                                return Column(
                                  children: [
                                    Expanded(
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
                                    SizedBox(
                                      height: 300,
                                      child: _LiveChatPanel(
                                        currentUserId: currentUser?.id ?? '',
                                        currentUserName: currentUser?.name ?? 'Guest',
                                        roomId: widget.eventId,
                                      ),
                                    ),
                                  ],
                                );
                              }

                              return Row(
                                children: [
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
                                  SizedBox(
                                    width: 360,
                                    child: _LiveChatPanel(
                                      currentUserId: currentUser?.id ?? '',
                                      currentUserName: currentUser?.name ?? 'Guest',
                                      roomId: widget.eventId,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          if (!isLoggedIn)
                            Positioned.fill(
                              child: Container(
                                color: Colors.black.withOpacity(0.7),
                                child: Center(
                                  child: Container(
                                    margin: const EdgeInsets.all(24),
                                    padding: const EdgeInsets.all(32),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Colors.white.withOpacity(0.15),
                                          Colors.white.withOpacity(0.05),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(24),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.2),
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.lock_outline,
                                          color: Color(0xFF9D4EDD),
                                          size: 64,
                                        ),
                                        const SizedBox(height: 24),
                                        const Text(
                                          'Login Required',
                                          style: TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          'Please log in to watch and chat in this live stream',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white.withOpacity(0.8),
                                          ),
                                        ),
                                        const SizedBox(height: 32),
                                        Container(
                                          decoration: BoxDecoration(
                                            gradient: const LinearGradient(
                                              colors: [
                                                Color(0xFF9D4EDD),
                                                Color(0xFF7B2CBF),
                                              ],
                                            ),
                                            borderRadius: BorderRadius.circular(12),
                                            boxShadow: [
                                              BoxShadow(
                                                color: const Color(0xFF9D4EDD).withOpacity(0.4),
                                                blurRadius: 20,
                                                offset: const Offset(0, 8),
                                              ),
                                            ],
                                          ),
                                          child: ElevatedButton(
                                            onPressed: () => context.pushNamed('login'),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.transparent,
                                              shadowColor: Colors.transparent,
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 48,
                                                vertical: 16,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                            ),
                                            child: const Text(
                                              'Go to Login',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _TopNavigationBar extends StatelessWidget {
  final dynamic currentUser;
  final bool isLoggedIn;

  const _TopNavigationBar({
    required this.currentUser,
    required this.isLoggedIn,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Logo
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF9D4EDD), Color(0xFF7B2CBF)],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.shopping_bag,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'LIVESHOP',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          
          const Spacer(),
          
          // Actions
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search, color: Colors.white),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.favorite_border, color: Colors.white),
          ),
          const SizedBox(width: 8),
          if (isLoggedIn)
            CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage(
                'https://picsum.photos/seed/${currentUser?.id ?? "user"}/200',
              ),
            )
          else
            IconButton(
              onPressed: () => context.pushNamed('login'),
              icon: const Icon(Icons.person_outline, color: Colors.white),
            ),
        ],
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
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF9D4EDD),
            ),
          );
        }
        if (state.error != null) {
          return Center(
            child: Text(
              'Error: ${state.error}',
              style: const TextStyle(color: Colors.white),
            ),
          );
        }
        final event = state.liveEvent;
        if (event == null) {
          return const Center(
            child: Text(
              'Event not found',
              style: TextStyle(color: Colors.white),
            ),
          );
        }
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Video Player
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: isInitialized
                            ? VideoPlayer(controller)
                            : const Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xFF9D4EDD),
                                ),
                              ),
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
              ),
              
              // Event Title and Stats
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            event.title,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: const [
                              Icon(Icons.circle, color: Colors.white, size: 8),
                              SizedBox(width: 6),
                              Text(
                                'LIVE',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          Icons.remove_red_eye,
                          size: 18,
                          color: Colors.white.withOpacity(0.7),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${state.viewerCount}',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Product List
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: event.products.map((product) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E2139),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              width: 70,
                              height: 70,
                              color: Colors.white.withOpacity(0.1),
                              child: Image.network(
                                product.thumbnail,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    Icons.image_not_supported,
                                    color: Colors.white.withOpacity(0.3),
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '\$${product.currentPrice.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF9D4EDD),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF9D4EDD),
                                  Color(0xFF7B2CBF),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: IconButton(
                              onPressed: () {
                                final cartBloc = context.read<CartBloc>();
                                cartBloc.add(
                                  CartItemAdded(
                                    productId: product.id,
                                    quantity: 1,
                                  ),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Added ${product.name} to cart'),
                                    backgroundColor: const Color(0xFF9D4EDD),
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.shopping_cart,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),
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

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1D2E),
        border: Border(
          left: BorderSide(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // Chat Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              border: Border(
                bottom: BorderSide(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
            ),
            child: const Row(
              children: [
                Text(
                  'Live Chat',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Spacer(),
                Icon(
                  Icons.chat_bubble_outline,
                  color: Color(0xFF9D4EDD),
                  size: 24,
                ),
              ],
            ),
          ),
          
          // Messages
          Expanded(
            child: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.messages.length,
                  itemBuilder: (context, index) {
                    final message = state.messages[index];
                    final isMe = message.senderId == currentUserId;
                    return _ChatMessageTile(message: message, isMe: isMe);
                  },
                );
              },
            ),
          ),
          
          // Input Field
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              border: Border(
                top: BorderSide(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Send a message...',
                      hintStyle: TextStyle(
                        color: Colors.white.withOpacity(0.4),
                      ),
                      filled: true,
                      fillColor: const Color(0xFF2A2D3E),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF9D4EDD),
                        Color(0xFF7B2CBF),
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatMessageTile extends StatelessWidget {
  final ChatMessage message;
  final bool isMe;

  const _ChatMessageTile({required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Avatar
          CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage(
              'https://picsum.photos/seed/${message.senderId}/200',
            ),
          ),
          const SizedBox(width: 12),
          
          // Message Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.senderName,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isMe ? const Color(0xFF9D4EDD) : Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isMe
                        ? const Color(0xFF9D4EDD).withOpacity(0.2)
                        : const Color(0xFF2A2D3E),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isMe
                          ? const Color(0xFF9D4EDD).withOpacity(0.3)
                          : Colors.white.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    message.message,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VideoControlsOverlay extends StatefulWidget {
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
  State<_VideoControlsOverlay> createState() => _VideoControlsOverlayState();
}

class _VideoControlsOverlayState extends State<_VideoControlsOverlay> {
  bool _showControls = false;
  bool _showVolumeSlider = false;
  Timer? _hideTimer;

  @override
  void dispose() {
    _hideTimer?.cancel();
    super.dispose();
  }

  void _onHover() {
    setState(() {
      _showControls = true;
    });
    _resetHideTimer();
  }

  void _resetHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 3), () {
      if (mounted && !_showVolumeSlider) {
        setState(() {
          _showControls = false;
        });
      }
    });
  }

  void _toggleVolumeSlider() {
    setState(() {
      _showVolumeSlider = !_showVolumeSlider;
      if (_showVolumeSlider) {
        _hideTimer?.cancel();
      } else {
        _resetHideTimer();
      }
    });
  }

  void _skipBackward() {
    final currentPosition = widget.controller.value.position;
    final newPosition = currentPosition - const Duration(seconds: 10);
    widget.controller.seekTo(
      newPosition < Duration.zero ? Duration.zero : newPosition,
    );
  }

  void _skipForward() {
    final currentPosition = widget.controller.value.position;
    final duration = widget.controller.value.duration;
    final newPosition = currentPosition + const Duration(seconds: 10);
    widget.controller.seekTo(
      newPosition > duration ? duration : newPosition,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onHover(),
      onHover: (_) => _onHover(),
      child: GestureDetector(
        onTap: _onHover,
        behavior: HitTestBehavior.translucent,
        child: Stack(
          children: [
            // Invisible full-area tap detector to close volume slider
            if (_showVolumeSlider)
              Positioned.fill(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _showVolumeSlider = false;
                      _resetHideTimer();
                    });
                  },
                  child: Container(color: Colors.transparent),
                ),
              ),
            
            // Control Bar
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              bottom: _showControls ? 16 : -60,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Skip Backward Button
                      IconButton(
                        onPressed: _skipBackward,
                        icon: const Icon(
                          Icons.replay_10,
                          color: Colors.white,
                          size: 24,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      const SizedBox(width: 16),
                      
                      // Play/Pause Button
                      IconButton(
                        onPressed: widget.onTogglePlay,
                        icon: Icon(
                          widget.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                          color: Colors.white,
                          size: 32,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      const SizedBox(width: 16),
                      
                      // Skip Forward Button
                      IconButton(
                        onPressed: _skipForward,
                        icon: const Icon(
                          Icons.forward_10,
                          color: Colors.white,
                          size: 24,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      const SizedBox(width: 16),
                      
                      // Volume Icon with Slider
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          IconButton(
                            onPressed: _toggleVolumeSlider,
                            icon: Icon(
                              widget.volume == 0
                                  ? Icons.volume_off
                                  : Icons.volume_up,
                              color: Colors.white,
                              size: 24,
                            ),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                          
                          // Vertical Volume Slider
                          if (_showVolumeSlider)
                            Positioned(
                              bottom: 48,
                              left: -8,
                              child: GestureDetector(
                                onTap: () {}, // Prevent closing when tapping slider
                                child: Container(
                                  width: 40,
                                  height: 120,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1E0A3C).withOpacity(0.95),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: const Color(0xFF6C5CE7).withOpacity(0.3),
                                      width: 1,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.3),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: RotatedBox(
                                    quarterTurns: 3,
                                    child: SliderTheme(
                                      data: SliderThemeData(
                                        trackHeight: 2,
                                        thumbShape: const RoundSliderThumbShape(
                                          enabledThumbRadius: 6,
                                        ),
                                        overlayShape: const RoundSliderOverlayShape(
                                          overlayRadius: 12,
                                        ),
                                        activeTrackColor: const Color(0xFF6C5CE7),
                                        inactiveTrackColor: const Color(0xFF4A4A5A),
                                        thumbColor: const Color(0xFF6C5CE7),
                                        overlayColor: const Color(0xFF6C5CE7).withOpacity(0.2),
                                      ),
                                      child: Slider(
                                        value: widget.volume,
                                        onChanged: (value) {
                                          widget.onVolumeChanged(value);
                                        },
                                        min: 0,
                                        max: 1,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
