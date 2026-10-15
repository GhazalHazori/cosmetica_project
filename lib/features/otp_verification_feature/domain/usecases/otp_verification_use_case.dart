import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/otp_verification_entity.dart';
import '../entities/pending_verification_entity.dart';
import '../repositories/otp_verification_repository.dart';

class VerifyOtpUseCase {
  final OtpVerificationRepository _repository;

  VerifyOtpUseCase(this._repository);

  Future<Either<Failure, void>> call(OtpVerificationEntity params) {
    return _repository.verifyOtp(params);
  }
}

class ResendOtpUseCase {
  final OtpVerificationRepository _repository;

  ResendOtpUseCase(this._repository);

  Future<Either<Failure, void>> call(String phoneNumber) {
    return _repository.resendOtp(phoneNumber);
  }
}

/// The registration awaiting verification on this device, so the app can
/// reopen on the code screen.
class GetPendingVerificationUseCase {
  final OtpVerificationRepository _repository;

  GetPendingVerificationUseCase(this._repository);

  PendingVerificationEntity? call() => _repository.getPendingVerification();
}

class SavePendingVerificationUseCase {
  final OtpVerificationRepository _repository;

  SavePendingVerificationUseCase(this._repository);

  Future<void> call(PendingVerificationEntity pending) {
    return _repository.savePendingVerification(pending);
  }
}

/// Abandons the pending verification (e.g. the user goes back to sign in).
class ClearPendingVerificationUseCase {
  final OtpVerificationRepository _repository;

  ClearPendingVerificationUseCase(this._repository);

  Future<void> call() => _repository.clearPendingVerification();
}
