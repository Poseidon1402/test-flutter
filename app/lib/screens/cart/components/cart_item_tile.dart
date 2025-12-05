part of '../cart_screen.dart';

class _CartItemTile extends StatelessWidget {
  final String thumbnailUrl;
  final String name;
  final double unitPrice;
  final int quantity;
  final VoidCallback onRemove;

  const _CartItemTile({
    required this.thumbnailUrl,
    required this.name,
    required this.unitPrice,
    required this.quantity,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 60,
              height: 60,
              color: Colors.white.withValues(alpha: 0.1),
              child: CachedNetworkImage(
                imageUrl: thumbnailUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                  );
                },
                imageBuilder: (context, imageProvider) =>
                    Image(image: imageProvider, fit: BoxFit.cover),
                errorWidget: (context, error, stackTrace) {
                  return Icon(
                    Icons.image_not_supported,
                    color: Colors.white.withValues(alpha: 0.3),
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
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '$quantity x €${unitPrice.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onRemove,
            icon: Icon(
              Icons.delete_outline,
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}
