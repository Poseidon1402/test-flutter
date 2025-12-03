part of '../live_event_screen.dart';

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
    widget.controller.seekTo(newPosition > duration ? duration : newPosition);
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
                      IconButton(
                        onPressed: widget.onTogglePlay,
                        icon: Icon(
                          widget.isPlaying ? Icons.pause : Icons.play_arrow,
                          color: Colors.white,
                          size: 32,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      const SizedBox(width: 16),
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
                          if (_showVolumeSlider)
                            Positioned(
                              bottom: 48,
                              left: -8,
                              child: GestureDetector(
                                onTap: () {},
                                child: Container(
                                  width: 40,
                                  height: 120,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFF1E0A3C,
                                    ).withOpacity(0.95),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: const Color(
                                        0xFF6C5CE7,
                                      ).withOpacity(0.3),
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
                                        overlayShape:
                                            const RoundSliderOverlayShape(
                                              overlayRadius: 12,
                                            ),
                                        activeTrackColor: const Color(
                                          0xFF6C5CE7,
                                        ),
                                        inactiveTrackColor: const Color(
                                          0xFF4A4A5A,
                                        ),
                                        thumbColor: const Color(0xFF6C5CE7),
                                        overlayColor: const Color(
                                          0xFF6C5CE7,
                                        ).withOpacity(0.2),
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
