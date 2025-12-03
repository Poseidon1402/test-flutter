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
// Removed unused mock services imports
import '../../services/socket_io_service.dart';
part 'components/top_navigation_bar.dart';
part 'components/live_video_and_products.dart';
part 'components/live_chat_panel.dart';
part 'components/chat_message_tile.dart';
part 'components/video_controls_overlay.dart';

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
  late final SocketIoService _ioSocket;
  StreamSubscription? _viewerSub;

  @override
  void initState() {
    super.initState();
    _ioSocket = SocketIoService();
    _ioSocket.connect();
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

    // Start watching to increment viewers; username will be refined in build
    _ioSocket.watchLive(room: widget.eventId, username: 'Guest');
    // Listen for viewer count updates for this event and forward to Bloc
    _viewerSub = _ioSocket.viewerCountStream.listen((update) {
      if (update.room == widget.eventId && mounted) {
        try {
          final bloc = context.read<LiveEventBloc>();
          bloc.add(LiveEventViewerCountUpdated(update.count));
        } catch (_) {
          // Bloc not available yet; ignore early updates
        }
      }
    });
    // Notify Bloc that event screen is opened
    context.read<LiveEventBloc>().add(LiveEventOpened(widget.eventId));
  }

  @override
  void dispose() {
    _viewerSub?.cancel();
    _ioSocket.leaveLive(room: widget.eventId);
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Removed unused locals: MockApiService and MockSocketService

    return MultiBlocProvider(
      providers: [
        BlocProvider<ChatBloc>(
          create: (_) =>
              ChatBloc(socket: _ioSocket)..add(ChatStarted(widget.eventId)),
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
                              // Ensure we watch with real username when available
                              final username = currentUser?.name ?? 'Guest';
                              _ioSocket.watchLive(
                                room: widget.eventId,
                                username: username,
                              );

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
                                            if (_videoController
                                                .value
                                                .isPlaying) {
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
                                        currentUserName:
                                            currentUser?.name ?? 'Guest',
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
                                          if (_videoController
                                              .value
                                              .isPlaying) {
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
                                      currentUserName:
                                          currentUser?.name ?? 'Guest',
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
                                            color: Colors.white.withOpacity(
                                              0.8,
                                            ),
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
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: const Color(
                                                  0xFF9D4EDD,
                                                ).withOpacity(0.4),
                                                blurRadius: 20,
                                                offset: const Offset(0, 8),
                                              ),
                                            ],
                                          ),
                                          child: ElevatedButton(
                                            onPressed: () =>
                                                context.pushNamed('login'),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.transparent,
                                              shadowColor: Colors.transparent,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 48,
                                                    vertical: 16,
                                                  ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
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

// Component classes moved into parts under components/
