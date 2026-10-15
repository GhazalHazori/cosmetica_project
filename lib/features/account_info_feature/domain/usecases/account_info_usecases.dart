import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/account_info_entity.dart';
import '../entities/account_update_entity.dart';
import '../repositories/account_info_repository.dart';

class GetAccountInfoUseCase {
  final AccountInfoRepository _repository;

  GetAccountInfoUseCase(this._repository);

  Future<Either<Failure, AccountInfoEntity>> call() {
    return _repository.getAccountInfo();
  }
}

/// Saves the edited name and email, sending only what changed from
/// [current]. Nothing changed: no request, [current] is returned.
class UpdateAccountInfoUseCase {
  final AccountInfoRepository _repository;

  UpdateAccountInfoUseCase(this._repository);

  Future<Either<Failure, AccountInfoEntity>> call({
    required AccountInfoEntity current,
    required String fullName,
    required String email,
  }) async {
    final update = AccountUpdateEntity(
      fullName: fullName == current.fullName ? null : fullName,
      email: email == (current.email ?? '') ? null : email,
    );
    if (update.isEmpty) return Right(current);
    return _repository.updateAccountInfo(update);
  }
}

class UpdateProfilePhotoUseCase {
  final AccountInfoRepository _repository;

  UpdateProfilePhotoUseCase(this._repository);

  Future<Either<Failure, AccountInfoEntity>> call(String photoPath) {
    return _repository.updateAccountInfo(
      AccountUpdateEntity(photoPath: photoPath),
    );
  }
}
