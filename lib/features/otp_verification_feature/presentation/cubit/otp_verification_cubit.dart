import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/otp_verification_entity.dart';
import '../../domain/usecases/otp_verification_use_case.dart';

part 'otp_verification_state.dart';

class OtpVerificationCubit extends Cubit<OtpVerificationState> {
  final VerifyOtpUseCase _verifyOtpUseCase;
  final ResendOtpUseCase _resendOtpUseCase;

  OtpVerificationCubit(this._verifyOtpUseCase, this._resendOtpUseCase)
      : super(const OtpVerificationState.initial());

  Future<void> verifyOtp(OtpVerificationEntity params) async {
    emit(state.copyWith(status: OtpVerificationStatus.loading));

    final result = await _verifyOtpUseCase(params);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: OtpVerificationStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(const OtpVerificationState(status: OtpVerificationStatus.success)),
    );
  }

  Future<void> resendOtp(String phoneNumber) async {
    emit(state.copyWith(status: OtpVerificationStatus.loading));

    final result = await _resendOtpUseCase(phoneNumber);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: OtpVerificationStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(const OtpVerificationState(status: OtpVerificationStatus.success)),
    );
  }

  void reset() {
    emit(const OtpVerificationState.initial());
  }
}
