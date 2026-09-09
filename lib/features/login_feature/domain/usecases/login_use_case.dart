import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/login_entity.dart';
import '../repositories/login_repository.dart';

class LoginUseCase {
  final LoginRepository _repository;

  LoginUseCase(this._repository);

  Future<Either<Failure, void>> call(LoginEntity params) {
    return _repository.login(params);
  }
}
