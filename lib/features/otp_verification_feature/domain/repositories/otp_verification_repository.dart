import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/otp_verification_entity.dart';
import '../entities/pending_verification_entity.dart';

abstract class OtpVerificationRepository {
  /// Verifies the code; on success the pending verification is cleared.
  Future<Either<Failure, void>> verifyOtp(OtpVerificationEntity params);

  /// Sends a new code; on success the pending verification's code time is
  /// refreshed.
  Future<Either<Failure, void>> resendOtp(String phoneNumber);

  /// The registration awaiting verification on this device, if any.
  PendingVerificationEntity? getPendingVerification();

  Future<void> savePendingVerification(PendingVerificationEntity pending);

  Future<void> clearPendingVerification();
}
