part of 'auth_bloc.dart';

enum AuthStatus { unauthenticated, authenticated }

class AuthState extends Equatable {
  final AuthStatus status;
  final User? user;
  final bool isLoading;
  final String? error;

  const AuthState({
    required this.status,
    this.user,
    this.isLoading = false,
    this.error,
  });

  const AuthState.unauthenticated({String? error})
      : this(status: AuthStatus.unauthenticated, user: null, isLoading: false, error: error);

  const AuthState.authenticated(User user)
      : this(status: AuthStatus.authenticated, user: user, isLoading: false);

  AuthState copyWith({
    AuthStatus? status,
    User? user,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, user, isLoading, error];
}
