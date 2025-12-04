part of 'orders_bloc.dart';

class OrdersState extends Equatable {
  final List<Order> orders;
  final bool isLoading;
  final String? error;

  const OrdersState({
    required this.orders,
    required this.isLoading,
    this.error,
  });

  const OrdersState.initial()
      : this(
          orders: const [],
          isLoading: false,
        );

  OrdersState copyWith({
    List<Order>? orders,
    bool? isLoading,
    String? error,
  }) {
    return OrdersState(
      orders: orders ?? this.orders,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [orders, isLoading, error];
}
