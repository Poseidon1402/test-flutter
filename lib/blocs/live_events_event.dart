part of 'live_events_bloc.dart';

abstract class LiveEventsEvent extends Equatable {
  const LiveEventsEvent();

  @override
  List<Object?> get props => [];
}

class LiveEventsRequested extends LiveEventsEvent {
  const LiveEventsRequested();
}
