import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/account_info_entity.dart';
import '../../domain/entities/account_update_entity.dart';
import '../../domain/repositories/account_info_repository.dart';
import '../datasources/account_info_remote_data_source.dart';
import '../models/account_update_model.dart';

class AccountInfoRepositoryImpl implements AccountInfoRepository {
  AccountInfoRepositoryImpl({
    required AccountInfoRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  final AccountInfoRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, AccountInfoEntity>> getAccountInfo() {
    return _guard(_remoteDataSource.getAccountInfo);
  }

  @override
  Future<Either<Failure, AccountInfoEntity>> updateAccountInfo(
    AccountUpdateEntity update,
  ) {
    return _guard(
      () => _remoteDataSource.updateAccountInfo(
        AccountUpdateModel.fromEntity(update),
      ),
    );
  }

  Future<Either<Failure, AccountInfoEntity>> _guard(
    Future<AccountInfoEntity> Function() call,
  ) async {
    try {
      return Right(await call());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ParsingFailure(e.toString()));
    }
  }
}
