part of '../product_detail_screen.dart';

class _QuantitySelector extends StatelessWidget {
  final int quantity;
  final ValueChanged<int> onChanged;

  const _QuantitySelector({required this.quantity, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quantité',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white.withOpacity(0.9),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 140,
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFF2A2D3E),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                splashRadius: 20,
                icon: const Icon(Icons.remove, color: Colors.white),
                onPressed: () {
                  final next = quantity > 1 ? quantity - 1 : 1;
                  if (next != quantity) onChanged(next);
                },
              ),
              Text(
                '$quantity',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                splashRadius: 20,
                icon: const Icon(Icons.add, color: Colors.white),
                onPressed: () {
                  final next = quantity < 99 ? quantity + 1 : 99;
                  if (next != quantity) onChanged(next);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
