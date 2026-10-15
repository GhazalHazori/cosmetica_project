import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/new_password_entity.dart';
import '../../domain/entities/reset_code_entity.dart';
import '../../domain/usecases/reset_password_usecases.dart';

part 'reset_password_state.dart';

/// Phone → code → new password.
class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  ResetPasswordCubit(
    this._requestCode,
    this._verifyCode,
    this._completeReset,
  ) : super(const ResetPasswordState.initial());

  final RequestResetCodeUseCase _requestCode;
  final VerifyResetCodeUseCase _verifyCode;
  final CompleteResetPasswordUseCase _completeReset;

  Future<void> requestCode(String phone) {
    return _run(
      () => _requestCode(phone),
      onSuccess: () => state.copyWith(
        step: ResetPasswordStep.code,
        status: ResetPasswordStatus.codeSent,
        phone: phone,
      ),
    );
  }

  Future<void> resendCode() => requestCode(state.phone);

  Future<void> verifyCode(String code) {
    return _run(
      () => _verifyCode(ResetCodeEntity(phone: state.phone, code: code)),
      onSuccess: () => state.copyWith(
        step: ResetPasswordStep.newPassword,
        status: ResetPasswordStatus.initial,
      ),
    );
  }

  Future<void> completeReset(String newPassword) {
    return _run(
      () => _completeReset(
        NewPasswordEntity(phone: state.phone, newPassword: newPassword),
      ),
      onSuccess: () =>
          state.copyWith(status: ResetPasswordStatus.completed),
    );
  }

  /// Goes back one step; returns false on the first step.
  bool back() {
    final previous = switch (state.step) {
      ResetPasswordStep.phone => null,
      ResetPasswordStep.code => ResetPasswordStep.phone,
      ResetPasswordStep.newPassword => ResetPasswordStep.code,
    };
    if (previous == null) return false;
    emit(
      state.copyWith(step: previous, status: ResetPasswordStatus.initial),
    );
    return true;
  }

  Future<void> _run(
    Future<Either<Failure, void>> Function() call, {
    required ResetPasswordState Function() onSuccess,
  }) async {
    emit(state.copyWith(status: ResetPasswordStatus.loading));

    final result = await call();

    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ResetPasswordStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(onSuccess()),
    );
  }
}
