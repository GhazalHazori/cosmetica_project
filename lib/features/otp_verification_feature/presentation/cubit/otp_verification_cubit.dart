import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/otp_verification_entity.dart';
import '../../domain/entities/pending_verification_entity.dart';
import '../../domain/usecases/otp_verification_use_case.dart';

part 'otp_verification_state.dart';

class OtpVerificationCubit extends Cubit<OtpVerificationState> {
  final VerifyOtpUseCase _verifyOtpUseCase;
  final ResendOtpUseCase _resendOtpUseCase;
  final SavePendingVerificationUseCase _savePendingVerificationUseCase;
  final ClearPendingVerificationUseCase _clearPendingVerificationUseCase;

  OtpVerificationCubit(
    this._verifyOtpUseCase,
    this._resendOtpUseCase,
    this._savePendingVerificationUseCase,
    this._clearPendingVerificationUseCase,
  ) : super(const OtpVerificationState.initial());

  /// Remembers this verification so the app can reopen on it, and sends a
  /// code first when [sendCode] is set (resuming from sign-in or a second
  /// registration, where no code has just been sent).
  ///
  /// [codeSentAt] is when the current code was sent; `null` with [sendCode].
  Future<void> start({
    required String phoneNumber,
    required bool isBusiness,
    DateTime? codeSentAt,
    bool sendCode = false,
  }) async {
    await _savePendingVerificationUseCase(
      PendingVerificationEntity(
        phoneNumber: phoneNumber,
        isBusiness: isBusiness,
        // No code yet: treat it as long expired until one is sent.
        codeSentAt: codeSentAt ?? DateTime.fromMillisecondsSinceEpoch(0),
      ),
    );
    if (sendCode) await resendOtp(phoneNumber);
  }

  Future<void> verifyOtp(OtpVerificationEntity params) async {
    emit(state.copyWith(status: OtpVerificationStatus.loading));

    final result = await _verifyOtpUseCase(params);

    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: OtpVerificationStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(
        const OtpVerificationState(status: OtpVerificationStatus.success),
      ),
    );
  }

  Future<void> resendOtp(String phoneNumber) async {
    emit(state.copyWith(status: OtpVerificationStatus.loading));

    final result = await _resendOtpUseCase(phoneNumber);

    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: OtpVerificationStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(
        const OtpVerificationState(status: OtpVerificationStatus.resent),
      ),
    );
  }

  /// Gives up on this verification (the user goes back to sign in), so the
  /// app no longer reopens on it.
  Future<void> abandon() => _clearPendingVerificationUseCase();

  void reset() {
    emit(const OtpVerificationState.initial());
  }
}
