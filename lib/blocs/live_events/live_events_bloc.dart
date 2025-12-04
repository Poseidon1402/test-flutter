import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/live_event.dart';
import '../../services/mock_api_service.dart';

part 'live_events_event.dart';
part 'live_events_state.dart';

class LiveEventsBloc extends Bloc<LiveEventsEvent, LiveEventsState> {
  final MockApiService api;

  LiveEventsBloc(this.api) : super(const LiveEventsState.loading()) {
    on<LiveEventsRequested>(_onRequested);
    on<LiveEventsSearchChanged>(_onSearchChanged);
    on<LiveEventsFilterStatusChanged>(_onFilterStatusChanged);
    on<LiveEventsViewerCountUpdated>(_onViewerCountUpdated);
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

  void _onSearchChanged(
    LiveEventsSearchChanged event,
    Emitter<LiveEventsState> emit,
  ) {
    emit(state.copyWith(searchQuery: event.query));
  }

  void _onFilterStatusChanged(
    LiveEventsFilterStatusChanged event,
    Emitter<LiveEventsState> emit,
  ) {
    emit(state.copyWith(filterStatus: event.status));
  }

  void _onViewerCountUpdated(
    LiveEventsViewerCountUpdated event,
    Emitter<LiveEventsState> emit,
  ) {
    final updatedEvents = state.events.map((liveEvent) {
      if (liveEvent.id == event.eventId) {
        return liveEvent.copyWith(viewerCount: event.viewerCount);
      }
      return liveEvent;
    }).toList();

    emit(state.copyWith(events: updatedEvents));
  }
}
