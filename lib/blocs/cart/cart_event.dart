part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class CartRequested extends CartEvent {
  const CartRequested();
}

class CartItemAdded extends CartEvent {
  final String productId;
  final int quantity;
  final Map<String, String>? variations;

  const CartItemAdded({
    required this.productId,
    this.quantity = 1,
    this.variations,
  });

  @override
  List<Object?> get props => [productId, quantity, variations];
}

class CartItemQuantityUpdated extends CartEvent {
  final String cartItemId;
  final int quantity;

  const CartItemQuantityUpdated({
    required this.cartItemId,
    required this.quantity,
  });

  @override
  List<Object?> get props => [cartItemId, quantity];
}

class CartItemRemoved extends CartEvent {
  final String cartItemId;

  const CartItemRemoved(this.cartItemId);

  @override
  List<Object?> get props => [cartItemId];
}

class CartCleared extends CartEvent {
  const CartCleared();
}
