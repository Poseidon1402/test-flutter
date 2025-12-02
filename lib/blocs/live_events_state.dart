part of 'live_events_bloc.dart';

class LiveEventsState extends Equatable {
  final bool isLoading;
  final List<LiveEvent> events;
  final String? error;

  const LiveEventsState._({
    required this.isLoading,
    required this.events,
    this.error,
  });

  const LiveEventsState.loading() : this._(isLoading: true, events: const []);

  const LiveEventsState.success(List<LiveEvent> events)
      : this._(isLoading: false, events: events);

  const LiveEventsState.failure(String message)
      : this._(isLoading: false, events: const [], error: message);

  @override
  List<Object?> get props => [isLoading, events, error];
}
