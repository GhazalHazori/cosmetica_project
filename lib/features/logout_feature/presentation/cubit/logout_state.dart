part of 'logout_cubit.dart';

enum LogoutStatus { initial, loading, success, failure }

class LogoutState extends Equatable {
  final LogoutStatus status;
  final String? errorMessage;

  const LogoutState({required this.status, this.errorMessage});

  const LogoutState.initial()
      : status = LogoutStatus.initial,
        errorMessage = null;

  @override
  List<Object?> get props => [status, errorMessage];
}
