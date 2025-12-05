part of '../product_detail_screen.dart';

class _ProductImage extends StatelessWidget {
  final String imageUrl;
  final bool isWide;

  const _ProductImage({required this.imageUrl, required this.isWide});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        height: isWide ? 420 : 260,
      ),
    );
  }
}
