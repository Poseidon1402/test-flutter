part of '../login_screen.dart';

class _DecorativeIcon extends StatelessWidget {
  final IconData icon;
  final double rotation;
  final double opacity;

  const _DecorativeIcon({
    required this.icon,
    required this.rotation,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: rotation,
      child: Icon(icon, size: 120, color: Colors.white.withOpacity(opacity)),
    );
  }
}
