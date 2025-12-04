part of 'live_events_bloc.dart';

class LiveEventsState extends Equatable {
  final bool isLoading;
  final List<LiveEvent> events;
  final String? error;
  final String searchQuery;
  final LiveEventStatus? filterStatus;

  const LiveEventsState._({
    required this.isLoading,
    required this.events,
    this.error,
    this.searchQuery = '',
    this.filterStatus,
  });

  const LiveEventsState.loading()
      : this._(isLoading: true, events: const []);

  const LiveEventsState.success(List<LiveEvent> events)
      : this._(isLoading: false, events: events);

  const LiveEventsState.failure(String message)
      : this._(isLoading: false, events: const [], error: message);

  LiveEventsState copyWith({
    bool? isLoading,
    List<LiveEvent>? events,
    String? error,
    String? searchQuery,
    LiveEventStatus? filterStatus,
  }) {
    return LiveEventsState._(
      isLoading: isLoading ?? this.isLoading,
      events: events ?? this.events,
      error: error,
      searchQuery: searchQuery ?? this.searchQuery,
      filterStatus: filterStatus ?? this.filterStatus,
    );
  }

  @override
  List<Object?> get props => [isLoading, events, error, searchQuery, filterStatus];
}
