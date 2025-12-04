part of '../home_screen.dart';

class _ImagePreview extends StatelessWidget {
  final LiveEventStatus status;
  final String thumbnailUrl;
  final int viewerCount;

  const _ImagePreview({
    required this.status,
    required this.thumbnailUrl,
    required this.viewerCount,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.network(
              thumbnailUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: const Color(0xFF3A3D4E),
                  child: const Icon(
                    Icons.image_not_supported,
                    color: Colors.white30,
                    size: 48,
                  ),
                );
              },
            ),
          ),
        ),
        if (status == LiveEventStatus.live)
          Positioned(
            top: 12,
            left: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFFF3B30),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'EN DIRECT',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ),
      ],
    );
  }
}
