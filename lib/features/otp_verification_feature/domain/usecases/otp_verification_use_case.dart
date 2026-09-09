import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/otp_verification_entity.dart';
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
