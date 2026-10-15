import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/new_password_entity.dart';
import '../../domain/entities/reset_code_entity.dart';
import '../../domain/repositories/reset_password_repository.dart';
import '../datasources/reset_password_remote_data_source.dart';
import '../models/new_password_model.dart';
import '../models/reset_code_model.dart';

class ResetPasswordRepositoryImpl implements ResetPasswordRepository {
  ResetPasswordRepositoryImpl({
    required ResetPasswordRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  final ResetPasswordRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, void>> requestCode(String phone) {
    return _guard(() => _remoteDataSource.requestCode(phone));
  }

  @override
  Future<Either<Failure, void>> verifyCode(ResetCodeEntity params) {
    return _guard(
      () => _remoteDataSource.verifyCode(ResetCodeModel.fromEntity(params)),
    );
  }

  @override
  Future<Either<Failure, void>> completeReset(NewPasswordEntity params) {
    return _guard(
      () => _remoteDataSource.completeReset(
        NewPasswordModel.fromEntity(params),
      ),
    );
  }

  Future<Either<Failure, void>> _guard(Future<void> Function() call) async {
    try {
      await call();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ParsingFailure(e.toString()));
    }
  }
}
