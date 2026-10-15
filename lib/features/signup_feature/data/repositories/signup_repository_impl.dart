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
      await _remoteDataSource.signup(SignupModel.fromEntity(params));
      return const Right(null);
    } on ServerException catch (e) {
      // 409: the number already has an account, possibly one that was never
      // verified — the user can resume its verification.
      if (e.statusCode == 409) {
        return Left(PhoneAlreadyRegisteredFailure(e.message));
      }
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ParsingFailure(e.toString()));
    }
  }
}
