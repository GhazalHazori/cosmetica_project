import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/business_signup_entity.dart';
import '../../domain/repositories/business_signup_repository.dart';
import '../datasources/business_signup_remote_data_source.dart';
import '../models/business_signup_model.dart';

class BusinessSignupRepositoryImpl implements BusinessSignupRepository {
  BusinessSignupRepositoryImpl({
    required BusinessSignupRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  final BusinessSignupRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, void>> businessSignup(
    BusinessSignupEntity params,
  ) async {
    try {
      await _remoteDataSource.businessSignup(
        BusinessSignupModel.fromEntity(params),
      );
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
