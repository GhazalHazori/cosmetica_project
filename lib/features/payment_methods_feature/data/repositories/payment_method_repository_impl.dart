import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/payment_method_entity.dart';
import '../../domain/repositories/payment_method_repository.dart';
import '../datasources/payment_method_remote_data_source.dart';

class PaymentMethodRepositoryImpl implements PaymentMethodRepository {
  PaymentMethodRepositoryImpl({required PaymentMethodRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  final PaymentMethodRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, List<PaymentMethodEntity>>> getPaymentMethods() async {
    try {
      final result = await _remoteDataSource.getPaymentMethods();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(NetworkFailure(e.toString()));
    }
  }
}
