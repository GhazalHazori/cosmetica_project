import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/signup_entity.dart';

abstract class SignupRepository {
  Future<Either<Failure, void>> signup(SignupEntity params);
}
