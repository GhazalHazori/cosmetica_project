import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/account_info_entity.dart';
import '../entities/account_update_entity.dart';

abstract class AccountInfoRepository {
  Future<Either<Failure, AccountInfoEntity>> getAccountInfo();

  /// Returns the account as saved by the server.
  Future<Either<Failure, AccountInfoEntity>> updateAccountInfo(
    AccountUpdateEntity update,
  );
}
