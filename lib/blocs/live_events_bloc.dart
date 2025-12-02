import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../models/live_event.dart';
import '../services/mock_api_service.dart';

part 'live_events_event.dart';
part 'live_events_state.dart';

class LiveEventsBloc extends Bloc<LiveEventsEvent, LiveEventsState> {
  final MockApiService api;

  LiveEventsBloc(this.api) : super(const LiveEventsState.loading()) {
    on<LiveEventsRequested>(_onRequested);
  }

  Future<void> _onRequested(
    LiveEventsRequested event,
    Emitter<LiveEventsState> emit,
  ) async {
    emit(const LiveEventsState.loading());
    try {
      final events = await api.getLiveEvents();
      emit(LiveEventsState.success(events));
    } catch (e) {
      emit(LiveEventsState.failure(e.toString()));
    }
  }
}
