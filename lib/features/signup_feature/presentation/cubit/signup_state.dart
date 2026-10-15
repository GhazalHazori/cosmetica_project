part of 'signup_cubit.dart';

/// [phoneTaken]: the number already has an account, maybe one never
/// verified; [phone] is set so its verification can be resumed.
enum SignupStatus { initial, loading, success, phoneTaken, failure }

class SignupState extends Equatable {
  final SignupStatus status;
  final String? errorMessage;

  /// The phone number, set on success or [SignupStatus.phoneTaken] so it
  /// can be verified.
  final String? phone;

  const SignupState({
    required this.status,
    this.errorMessage,
    this.phone,
  });

  const SignupState.initial()
      : status = SignupStatus.initial,
        errorMessage = null,
        phone = null;

  SignupState copyWith({
    SignupStatus? status,
    String? errorMessage,
    String? phone,
  }) {
    return SignupState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      phone: phone ?? this.phone,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, phone];
}
