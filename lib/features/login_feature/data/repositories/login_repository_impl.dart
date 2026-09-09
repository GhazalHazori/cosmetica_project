import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/login_entity.dart';
import '../../domain/repositories/login_repository.dart';
import '../datasources/login_remote_data_source.dart';
import '../models/login_model.dart';

class LoginRepositoryImpl implements LoginRepository {
  LoginRepositoryImpl({required LoginRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  final LoginRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, void>> login(LoginEntity params) async {
    try {
      final model = LoginModel(
        identifier: params.identifier,
        password: params.password,
      );
      await _remoteDataSource.login(model);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(NetworkFailure(e.toString()));
    }
  }
}
