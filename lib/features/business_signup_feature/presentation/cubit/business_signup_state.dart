part of 'business_signup_cubit.dart';

/// [phoneTaken]: the number already has an account, maybe one never
/// verified; [phone] is set so its verification can be resumed.
enum BusinessSignupStatus { initial, loading, success, phoneTaken, failure }

class BusinessSignupState extends Equatable {
  final BusinessSignupStatus status;
  final String? errorMessage;

  /// The phone number, set on success or [BusinessSignupStatus.phoneTaken]
  /// so it can be verified.
  final String? phone;

  const BusinessSignupState({
    required this.status,
    this.errorMessage,
    this.phone,
  });

  const BusinessSignupState.initial()
      : status = BusinessSignupStatus.initial,
        errorMessage = null,
        phone = null;

  BusinessSignupState copyWith({
    BusinessSignupStatus? status,
    String? errorMessage,
    String? phone,
  }) {
    return BusinessSignupState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      phone: phone ?? this.phone,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, phone];
}
