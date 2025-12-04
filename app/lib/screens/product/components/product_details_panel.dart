part of '../product_detail_screen.dart';

class _ProductDetailsPanel extends StatelessWidget {
  final Product product;
  final double price;
  final List<String> sizes;
  final List<String> colors;
  final List<String> types;
  final String? selectedSize;
  final String? selectedColor;
  final String? selectedType;
  final ValueChanged<String?> onSizeChanged;
  final ValueChanged<String?> onColorChanged;
  final ValueChanged<String?> onTypeChanged;
  final int quantity;
  final ValueChanged<int> onQuantityChanged;

  const _ProductDetailsPanel({
    required this.product,
    required this.price,
    required this.sizes,
    required this.colors,
    required this.types,
    required this.selectedSize,
    required this.selectedColor,
    required this.selectedType,
    required this.onSizeChanged,
    required this.onColorChanged,
    required this.onTypeChanged,
    required this.quantity,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            product.description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                '\u20ac${price.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF9D4EDD),
                ),
              ),
              const SizedBox(width: 12),
              if (product.salePrice != null)
                Text(
                  '\u20ac${product.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withValues(alpha: 0.6),
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          if (sizes.isNotEmpty)
            _VariationSelector(
              label: 'Taille',
              options: sizes,
              value: selectedSize,
              onChanged: onSizeChanged,
            ),
          if (colors.isNotEmpty) ...[
            const SizedBox(height: 12),
            _VariationSelector(
              label: 'Couleur',
              options: colors,
              value: selectedColor,
              onChanged: onColorChanged,
            ),
          ],
          if (types.isNotEmpty) ...[
            const SizedBox(height: 12),
            _VariationSelector(
              label: 'Type',
              options: types,
              value: selectedType,
              onChanged: onTypeChanged,
            ),
          ],
          const SizedBox(height: 16),
          _QuantitySelector(quantity: quantity, onChanged: onQuantityChanged),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF9D4EDD), Color(0xFF7B2CBF)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      final variations = <String, String>{};
                      if (selectedSize != null) {
                        variations['size'] = selectedSize!;
                      }
                      if (selectedColor != null) {
                        variations['color'] = selectedColor!;
                      }
                      if (selectedType != null) {
                        variations['type'] = selectedType!;
                      }
                      context.read<CartBloc>().add(
                        CartItemAdded(
                          productId: product.id,
                          quantity: quantity,
                          variations: variations.isEmpty ? null : variations,
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Ajouté: ${product.name} (x$quantity)'),
                          backgroundColor: const Color(0xFF9D4EDD),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Ajouter au panier',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Acheter maintenant'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
