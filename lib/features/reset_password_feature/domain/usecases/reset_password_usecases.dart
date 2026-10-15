import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/new_password_entity.dart';
import '../entities/reset_code_entity.dart';
import '../repositories/reset_password_repository.dart';

class RequestResetCodeUseCase {
  RequestResetCodeUseCase(this._repository);

  final ResetPasswordRepository _repository;

  Future<Either<Failure, void>> call(String phone) {
    return _repository.requestCode(phone);
  }
}

class VerifyResetCodeUseCase {
  VerifyResetCodeUseCase(this._repository);

  final ResetPasswordRepository _repository;

  Future<Either<Failure, void>> call(ResetCodeEntity params) {
    return _repository.verifyCode(params);
  }
}

class CompleteResetPasswordUseCase {
  CompleteResetPasswordUseCase(this._repository);

  final ResetPasswordRepository _repository;

  Future<Either<Failure, void>> call(NewPasswordEntity params) {
    return _repository.completeReset(params);
  }
}
