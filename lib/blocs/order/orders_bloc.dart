import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/order.dart';
import '../../services/mock_api_service.dart';

part 'orders_event.dart';
part 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final MockApiService api;

  OrdersBloc({required this.api}) : super(const OrdersState.initial()) {
    on<OrdersRequested>(_onRequested);
  }

  Future<void> _onRequested(OrdersRequested event, Emitter<OrdersState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final orders = await api.getOrdersForUser(event.userId);
      emit(state.copyWith(isLoading: false, orders: orders));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
