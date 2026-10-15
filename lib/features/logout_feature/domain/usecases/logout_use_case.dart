import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../repositories/logout_repository.dart';

class LogoutUseCase {
  LogoutUseCase(this._repository);

  final LogoutRepository _repository;

  Future<Either<Failure, void>> call() {
    return _repository.logout();
  }
}
