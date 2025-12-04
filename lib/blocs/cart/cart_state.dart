part of 'cart_bloc.dart';

class CartState extends Equatable {
  final bool isLoading;
  final List<CartItem> items;
  final String? error;

  const CartState({
    required this.isLoading,
    required this.items,
    required this.error,
  });

  const CartState.initial() : this(isLoading: false, items: const [], error: null);

  double get subtotal =>
      items.fold(0, (sum, item) => sum + item.product.currentPrice * item.quantity);

  CartState copyWith({
    bool? isLoading,
    List<CartItem>? items,
    String? error,
  }) {
    return CartState(
      isLoading: isLoading ?? this.isLoading,
      items: items ?? this.items,
      error: error,
    );
  }

  @override
  List<Object?> get props => [isLoading, items, error];
}
