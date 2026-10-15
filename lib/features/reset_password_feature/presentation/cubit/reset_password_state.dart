part of 'reset_password_cubit.dart';

/// The screen the flow is on.
enum ResetPasswordStep { phone, code, newPassword }

/// [codeSent]: a code was sent (first time or resend).
/// [completed]: the new password was saved.
enum ResetPasswordStatus { initial, loading, codeSent, completed, failure }

class ResetPasswordState extends Equatable {
  final ResetPasswordStep step;
  final ResetPasswordStatus status;
  final String phone;
  final String? errorMessage;

  const ResetPasswordState({
    required this.step,
    required this.status,
    this.phone = '',
    this.errorMessage,
  });

  const ResetPasswordState.initial()
      : step = ResetPasswordStep.phone,
        status = ResetPasswordStatus.initial,
        phone = '',
        errorMessage = null;

  /// [errorMessage] is cleared unless given.
  ResetPasswordState copyWith({
    ResetPasswordStep? step,
    ResetPasswordStatus? status,
    String? phone,
    String? errorMessage,
  }) {
    return ResetPasswordState(
      step: step ?? this.step,
      status: status ?? this.status,
      phone: phone ?? this.phone,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [step, status, phone, errorMessage];
}
