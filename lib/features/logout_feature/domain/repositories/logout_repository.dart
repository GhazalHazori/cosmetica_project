import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

abstract class LogoutRepository {
  /// Revokes the refresh token on the server and clears the local session.
  Future<Either<Failure, void>> logout();
}
