import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/business_signup_entity.dart';
import '../../domain/repositories/business_signup_repository.dart';
import '../datasources/business_signup_remote_data_source.dart';
import '../models/business_signup_model.dart';

class BusinessSignupRepositoryImpl implements BusinessSignupRepository {
  BusinessSignupRepositoryImpl({required BusinessSignupRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  final BusinessSignupRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, void>> businessSignup(BusinessSignupEntity params) async {
    try {
      final model = BusinessSignupModel(
        username: params.username,
        email: params.email,
        phone: params.phone,
        password: params.password,
        confirmPassword: params.confirmPassword,
        commercialRegisterFile: params.commercialRegisterFile,
        agreeToTerms: params.agreeToTerms,
      );
      await _remoteDataSource.businessSignup(model);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(NetworkFailure(e.toString()));
    }
  }
}
