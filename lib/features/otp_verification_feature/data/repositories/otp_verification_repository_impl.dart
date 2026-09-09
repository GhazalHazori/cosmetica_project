import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/otp_verification_entity.dart';
import '../../domain/repositories/otp_verification_repository.dart';
import '../datasources/otp_verification_remote_data_source.dart';
import '../models/otp_verification_model.dart';

class OtpVerificationRepositoryImpl implements OtpVerificationRepository {
  OtpVerificationRepositoryImpl({required OtpVerificationRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  final OtpVerificationRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, void>> verifyOtp(OtpVerificationEntity params) async {
    try {
      final model = OtpVerificationModel(
        phoneNumber: params.phoneNumber,
        otpCode: params.otpCode,
      );
      await _remoteDataSource.verifyOtp(model);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(NetworkFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> resendOtp(String phoneNumber) async {
    try {
      await _remoteDataSource.resendOtp(phoneNumber);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(NetworkFailure(e.toString()));
    }
  }
}
