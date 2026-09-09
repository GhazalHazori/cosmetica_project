import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/otp_verification_entity.dart';

abstract class OtpVerificationRepository {
  Future<Either<Failure, void>> verifyOtp(OtpVerificationEntity params);
  Future<Either<Failure, void>> resendOtp(String phoneNumber);
}
