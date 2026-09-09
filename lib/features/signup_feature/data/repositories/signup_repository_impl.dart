import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/signup_entity.dart';
import '../../domain/repositories/signup_repository.dart';
import '../datasources/signup_remote_data_source.dart';
import '../models/signup_model.dart';

class SignupRepositoryImpl implements SignupRepository {
  SignupRepositoryImpl({required SignupRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  final SignupRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, void>> signup(SignupEntity params) async {
    try {
      final model = SignupModel(
        username: params.username,
        email: params.email,
        phone: params.phone,
        password: params.password,
        confirmPassword: params.confirmPassword,
        agreeToTerms: params.agreeToTerms,
        accountType: params.accountType,
      );
      await _remoteDataSource.signup(model);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(NetworkFailure(e.toString()));
    }
  }
}
