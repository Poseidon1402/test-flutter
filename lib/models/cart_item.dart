import 'package:equatable/equatable.dart';

import 'product.dart';

class CartItem extends Equatable {
  final String id;
  final Product product;
  final int quantity;
  final Map<String, String>? selectedVariations;

  const CartItem({
    required this.id,
    required this.product,
    required this.quantity,
    this.selectedVariations,
  });

  double get total => product.currentPrice * quantity;

  CartItem copyWith({
    int? quantity,
    Map<String, String>? selectedVariations,
  }) {
    return CartItem(
      id: id,
      product: product,
      quantity: quantity ?? this.quantity,
      selectedVariations: selectedVariations ?? this.selectedVariations,
    );
  }

  @override
  List<Object?> get props => [id, product, quantity, selectedVariations];
}
