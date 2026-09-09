import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/business_signup_entity.dart';
import '../repositories/business_signup_repository.dart';

class BusinessSignupUseCase {
  final BusinessSignupRepository _repository;

  BusinessSignupUseCase(this._repository);

  Future<Either<Failure, void>> call(BusinessSignupEntity params) {
    return _repository.businessSignup(params);
  }
}
