import 'package:cosmetica_project/features/otp_verification_feature/domain/entities/otp_verification_entity.dart';
import 'package:cosmetica_project/features/otp_verification_feature/domain/entities/pending_verification_entity.dart';
import 'package:cosmetica_project/features/otp_verification_feature/domain/repositories/otp_verification_repository.dart';
import 'package:cosmetica_project/features/otp_verification_feature/domain/usecases/otp_verification_use_case.dart';
import 'package:cosmetica_project/features/splash_feature/domain/repositories/session_repository.dart';
import 'package:cosmetica_project/features/splash_feature/domain/usecases/restore_session_use_case.dart';
import 'package:cosmetica_project/features/splash_feature/presentation/cubit/splash_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:cosmetica_project/core/error/failures.dart';
import 'package:flutter_test/flutter_test.dart';

class _Session implements SessionRepository {
  _Session(this.signedIn);
  final bool signedIn;

  @override
  Future<bool> restoreSession() async => signedIn;
}

class _Otp implements OtpVerificationRepository {
  _Otp(this.pending);
  final PendingVerificationEntity? pending;

  @override
  PendingVerificationEntity? getPendingVerification() => pending;

  @override
  Future<void> savePendingVerification(PendingVerificationEntity p) async {}

  @override
  Future<void> clearPendingVerification() async {}

  @override
  Future<Either<Failure, void>> verifyOtp(OtpVerificationEntity params) =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, void>> resendOtp(String phoneNumber) =>
      throw UnimplementedError();
}

Future<SplashState> _complete({
  required bool signedIn,
  PendingVerificationEntity? pending,
}) async {
  final cubit = SplashCubit(
    RestoreSessionUseCase(_Session(signedIn)),
    GetPendingVerificationUseCase(_Otp(pending)),
  )..start();
  await cubit.onVideoCompleted();
  final state = cubit.state;
  await cubit.close();
  return state;
}

void main() {
  final pending = PendingVerificationEntity(
    phoneNumber: '+963944000104',
    isBusiness: false,
    codeSentAt: DateTime(2026, 10, 15),
  );

  test('signed in goes home, even with a stale pending verification',
      () async {
    final state = await _complete(signedIn: true, pending: pending);
    expect(state.destination, SplashDestination.home);
  });

  test('a registration left unverified reopens on the code screen', () async {
    final state = await _complete(signedIn: false, pending: pending);
    expect(state.destination, SplashDestination.otpVerification);
    expect(state.pendingVerification, pending);
  });

  test('otherwise login', () async {
    final state = await _complete(signedIn: false);
    expect(state.destination, SplashDestination.login);
  });
}
