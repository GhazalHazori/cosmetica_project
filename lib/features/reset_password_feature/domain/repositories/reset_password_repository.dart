import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/new_password_entity.dart';
import '../entities/reset_code_entity.dart';

abstract class ResetPasswordRepository {
  /// Sends a reset code to the customer's registered mobile number.
  Future<Either<Failure, void>> requestCode(String phone);

  Future<Either<Failure, void>> verifyCode(ResetCodeEntity params);

  /// Sets the new password once the code has been verified.
  Future<Either<Failure, void>> completeReset(NewPasswordEntity params);
}
