import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/auth_user_entity.dart';
import '../entities/login_entity.dart';

abstract class LoginRepository {
  /// Signs in and persists the session tokens.
  Future<Either<Failure, AuthUserEntity>> login(LoginEntity params);
}
