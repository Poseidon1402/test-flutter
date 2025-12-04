part of 'orders_bloc.dart';

abstract class OrdersEvent extends Equatable {
  const OrdersEvent();

  @override
  List<Object?> get props => [];
}

class OrdersRequested extends OrdersEvent {
  final String userId;

  const OrdersRequested(this.userId);

  @override
  List<Object?> get props => [userId];
}
