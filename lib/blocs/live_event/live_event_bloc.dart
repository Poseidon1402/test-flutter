import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/live_event.dart';
import '../../services/mock_api_service.dart';
import '../../services/mock_socket_service.dart';

part 'live_event_event.dart';
part 'live_event_state.dart';

class LiveEventBloc extends Bloc<LiveEventEvent, LiveEventState> {
  final MockApiService api;
  final MockSocketService socket;

  LiveEventBloc({required this.api, required this.socket})
    : super(const LiveEventState.initial()) {
    on<LiveEventOpened>(_onOpened);
    on<LiveEventViewerCountUpdated>(_onViewerUpdated);
  }

  Future<void> _onOpened(
    LiveEventOpened event,
    Emitter<LiveEventState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final liveEvent = await api.getLiveEventById(event.eventId);
      if (liveEvent == null) {
        emit(state.copyWith(isLoading: false, error: 'Event not found'));
        return;
      }
      await socket.joinLiveEvent(
        liveEvent.id,
        initialViewers: liveEvent.viewerCount,
      );
      emit(
        state.copyWith(
          isLoading: false,
          liveEvent: liveEvent,
          viewerCount: liveEvent.viewerCount,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  void _onViewerUpdated(
    LiveEventViewerCountUpdated event,
    Emitter<LiveEventState> emit,
  ) {
    emit(state.copyWith(viewerCount: event.viewerCount));
    print('state ${state}');
  }
}
