part of 'live_event_bloc.dart';

class LiveEventState extends Equatable {
  final bool isLoading;
  final LiveEvent? liveEvent;
  final int viewerCount;
  final String? error;

  const LiveEventState({
    required this.isLoading,
    required this.liveEvent,
    required this.viewerCount,
    this.error,
  });

  const LiveEventState.initial()
      : this(isLoading: false, liveEvent: null, viewerCount: 0);

  LiveEventState copyWith({
    bool? isLoading,
    LiveEvent? liveEvent,
    int? viewerCount,
    String? error,
  }) {
    return LiveEventState(
      isLoading: isLoading ?? this.isLoading,
      liveEvent: liveEvent ?? this.liveEvent,
      viewerCount: viewerCount ?? this.viewerCount,
      error: error,
    );
  }

  @override
  List<Object?> get props => [isLoading, liveEvent, viewerCount, error];
}
