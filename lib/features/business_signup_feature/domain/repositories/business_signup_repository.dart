import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/business_signup_entity.dart';

abstract class BusinessSignupRepository {
  Future<Either<Failure, void>> businessSignup(BusinessSignupEntity params);
}
