import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/otp_verification_entity.dart';
import '../../domain/entities/pending_verification_entity.dart';
import '../../domain/repositories/otp_verification_repository.dart';
import '../datasources/otp_verification_remote_data_source.dart';
import '../datasources/pending_verification_local_data_source.dart';
import '../models/otp_verification_model.dart';
import '../models/pending_verification_model.dart';

class OtpVerificationRepositoryImpl implements OtpVerificationRepository {
  OtpVerificationRepositoryImpl({
    required OtpVerificationRemoteDataSource remoteDataSource,
    required PendingVerificationLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  final OtpVerificationRemoteDataSource _remoteDataSource;
  final PendingVerificationLocalDataSource _localDataSource;

  @override
  Future<Either<Failure, void>> verifyOtp(OtpVerificationEntity params) {
    return _guard(() async {
      await _remoteDataSource
          .verifyOtp(OtpVerificationModel.fromEntity(params));
      await _localDataSource.clear();
    });
  }

  @override
  Future<Either<Failure, void>> resendOtp(String phoneNumber) {
    return _guard(() async {
      await _remoteDataSource.resendOtp(phoneNumber);
      final pending = getPendingVerification();
      if (pending != null && pending.phoneNumber == phoneNumber) {
        await savePendingVerification(
          PendingVerificationEntity(
            phoneNumber: phoneNumber,
            isBusiness: pending.isBusiness,
            codeSentAt: DateTime.now(),
          ),
        );
      }
    });
  }

  @override
  PendingVerificationEntity? getPendingVerification() {
    try {
      return _localDataSource.read();
    } on FormatException {
      // Unreadable leftover from an older format: nothing to resume.
      _localDataSource.clear();
      return null;
    } on TypeError {
      _localDataSource.clear();
      return null;
    }
  }

  @override
  Future<void> savePendingVerification(PendingVerificationEntity pending) {
    return _localDataSource.save(PendingVerificationModel.fromEntity(pending));
  }

  @override
  Future<void> clearPendingVerification() => _localDataSource.clear();

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
