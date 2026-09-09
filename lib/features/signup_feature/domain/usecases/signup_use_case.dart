import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/signup_entity.dart';
import '../repositories/signup_repository.dart';

class SignupUseCase {
  final SignupRepository _repository;

  SignupUseCase(this._repository);

  Future<Either<Failure, void>> call(SignupEntity params) {
    return _repository.signup(params);
  }
}
