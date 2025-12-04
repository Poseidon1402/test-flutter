import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/cart_item.dart';
import '../../services/mock_api_service.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final MockApiService api;

  CartBloc({required this.api}) : super(const CartState.initial()) {
    on<CartRequested>(_onRequested);
    on<CartItemAdded>(_onItemAdded);
    on<CartItemQuantityUpdated>(_onQuantityUpdated);
    on<CartItemRemoved>(_onItemRemoved);
    on<CartCleared>(_onCleared);
  }

  Future<void> _onRequested(CartRequested event, Emitter<CartState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final items = await api.getCart();
      emit(state.copyWith(isLoading: false, items: items));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onItemAdded(CartItemAdded event, Emitter<CartState> emit) async {
    try {
      await api.addToCart(event.productId, event.quantity, variations: event.variations);
      final items = await api.getCart();
      emit(state.copyWith(items: items));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onQuantityUpdated(
    CartItemQuantityUpdated event,
    Emitter<CartState> emit,
  ) async {
    try {
      await api.updateCartItem(event.cartItemId, event.quantity);
      final items = await api.getCart();
      emit(state.copyWith(items: items));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onItemRemoved(CartItemRemoved event, Emitter<CartState> emit) async {
    try {
      await api.removeFromCart(event.cartItemId);
      final items = await api.getCart();
      emit(state.copyWith(items: items));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onCleared(CartCleared event, Emitter<CartState> emit) async {
    try {
      await api.clearCart();
      final items = await api.getCart();
      emit(state.copyWith(items: items));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }
}
