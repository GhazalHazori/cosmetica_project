part of 'login_cubit.dart';

/// [accountPending]: the account exists but is not active yet; [identifier]
/// is set so its verification can be resumed.
enum LoginStatus { initial, loading, success, accountPending, failure }

class LoginState extends Equatable {
  final LoginStatus status;
  final String? errorMessage;
  final AuthUserEntity? user;

  /// The phone number signed in with.
  final String? identifier;

  const LoginState({
    required this.status,
    this.errorMessage,
    this.user,
    this.identifier,
  });

  const LoginState.initial()
      : status = LoginStatus.initial,
        errorMessage = null,
        user = null,
        identifier = null;

  LoginState copyWith({
    LoginStatus? status,
    String? errorMessage,
    AuthUserEntity? user,
    String? identifier,
  }) {
    return LoginState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      user: user ?? this.user,
      identifier: identifier ?? this.identifier,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, user, identifier];
}
