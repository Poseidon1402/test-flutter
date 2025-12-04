part of 'live_events_bloc.dart';

abstract class LiveEventsEvent extends Equatable {
  const LiveEventsEvent();

  @override
  List<Object?> get props => [];
}

class LiveEventsRequested extends LiveEventsEvent {
  const LiveEventsRequested();
}

class LiveEventsSearchChanged extends LiveEventsEvent {
  final String query;

  const LiveEventsSearchChanged(this.query);

  @override
  List<Object?> get props => [query];
}

class LiveEventsFilterStatusChanged extends LiveEventsEvent {
  final LiveEventStatus? status;

  const LiveEventsFilterStatusChanged(this.status);

  @override
  List<Object?> get props => [status];
}
