part of 'live_event_bloc.dart';

abstract class LiveEventEvent extends Equatable {
  const LiveEventEvent();

  @override
  List<Object?> get props => [];
}

class LiveEventOpened extends LiveEventEvent {
  final String eventId;

  const LiveEventOpened(this.eventId);

  @override
  List<Object?> get props => [eventId];
}

class LiveEventViewerCountUpdated extends LiveEventEvent {
  final int viewerCount;

  const LiveEventViewerCountUpdated(this.viewerCount);

  @override
  List<Object?> get props => [viewerCount];
}
