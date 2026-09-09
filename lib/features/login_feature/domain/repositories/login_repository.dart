import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/login_entity.dart';

abstract class LoginRepository {
  Future<Either<Failure, void>> login(LoginEntity params);
}
