import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../otp_verification_feature/domain/entities/pending_verification_entity.dart';
import '../../../otp_verification_feature/domain/usecases/otp_verification_use_case.dart';
import '../../domain/usecases/restore_session_use_case.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit(this._restoreSessionUseCase, this._getPendingVerificationUseCase)
      : super(const SplashState.initial());

  final RestoreSessionUseCase _restoreSessionUseCase;
  final GetPendingVerificationUseCase _getPendingVerificationUseCase;

  Future<bool>? _session;

  /// Starts refreshing a stored session while the animation plays.
  void start() {
    emit(const SplashState.initial());
    _session = _restoreSessionUseCase();
  }

  void onVideoInitialized() {
    emit(state.copyWith(status: SplashStatus.playing));
  }

  /// Waits for the session check, then completes with the destination:
  /// home when signed in, else the code screen of a registration left
  /// unverified on this device, else login.
  Future<void> onVideoCompleted() async {
    final isAuthenticated = await (_session ?? _restoreSessionUseCase());
    if (isClosed) return;

    final pending = isAuthenticated ? null : _getPendingVerificationUseCase();
    emit(
      state.copyWith(
        status: SplashStatus.completed,
        destination: isAuthenticated
            ? SplashDestination.home
            : pending != null
                ? SplashDestination.otpVerification
                : SplashDestination.login,
        pendingVerification: pending,
      ),
    );
  }

  void reset() {
    emit(const SplashState.initial());
  }
}
