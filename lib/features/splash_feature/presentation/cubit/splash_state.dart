part of 'splash_cubit.dart';

enum SplashStatus { initial, playing, completed }

class SplashState extends Equatable {
  final SplashStatus status;

  const SplashState({required this.status});

  const SplashState.initial() : status = SplashStatus.initial;

  SplashState copyWith({SplashStatus? status}) {
    return SplashState(
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [status];
}
