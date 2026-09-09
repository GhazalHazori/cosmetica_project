part of 'business_signup_cubit.dart';

enum BusinessSignupStatus { initial, loading, success, failure }

class BusinessSignupState extends Equatable {
  final BusinessSignupStatus status;
  final String? errorMessage;

  const BusinessSignupState({
    required this.status,
    this.errorMessage,
  });

  const BusinessSignupState.initial()
      : status = BusinessSignupStatus.initial,
        errorMessage = null;

  BusinessSignupState copyWith({
    BusinessSignupStatus? status,
    String? errorMessage,
  }) {
    return BusinessSignupState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}
