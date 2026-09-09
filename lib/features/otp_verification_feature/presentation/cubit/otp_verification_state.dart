part of 'otp_verification_cubit.dart';

enum OtpVerificationStatus { initial, loading, success, failure }

class OtpVerificationState extends Equatable {
  final OtpVerificationStatus status;
  final String? errorMessage;

  const OtpVerificationState({
    required this.status,
    this.errorMessage,
  });

  const OtpVerificationState.initial()
      : status = OtpVerificationStatus.initial,
        errorMessage = null;

  OtpVerificationState copyWith({
    OtpVerificationStatus? status,
    String? errorMessage,
  }) {
    return OtpVerificationState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}
