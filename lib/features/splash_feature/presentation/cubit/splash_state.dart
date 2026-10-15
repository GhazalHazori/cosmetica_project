part of 'splash_cubit.dart';

enum SplashStatus { initial, playing, completed }

/// Where the app opens once the splash completes.
enum SplashDestination { login, home, otpVerification }

class SplashState extends Equatable {
  final SplashStatus status;
  final SplashDestination destination;

  /// Set when [destination] is [SplashDestination.otpVerification]: the
  /// registration the user left before verifying its number.
  final PendingVerificationEntity? pendingVerification;

  const SplashState({
    required this.status,
    this.destination = SplashDestination.login,
    this.pendingVerification,
  });

  const SplashState.initial()
      : status = SplashStatus.initial,
        destination = SplashDestination.login,
        pendingVerification = null;

  SplashState copyWith({
    SplashStatus? status,
    SplashDestination? destination,
    PendingVerificationEntity? pendingVerification,
  }) {
    return SplashState(
      status: status ?? this.status,
      destination: destination ?? this.destination,
      pendingVerification: pendingVerification ?? this.pendingVerification,
    );
  }

  @override
  List<Object?> get props => [status, destination, pendingVerification];
}
