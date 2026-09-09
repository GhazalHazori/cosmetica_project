part of 'signup_cubit.dart';

enum SignupStatus { initial, loading, success, failure }

class SignupState extends Equatable {
  final SignupStatus status;
  final String? errorMessage;

  const SignupState({
    required this.status,
    this.errorMessage,
  });

  const SignupState.initial()
      : status = SignupStatus.initial,
        errorMessage = null;

  SignupState copyWith({
    SignupStatus? status,
    String? errorMessage,
  }) {
    return SignupState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}
