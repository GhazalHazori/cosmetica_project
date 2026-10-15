import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/completed_order_details_entity.dart';
import '../../domain/repositories/completed_order_details_repository.dart';
import '../datasources/completed_order_details_remote_data_source.dart';

class CompletedOrderDetailsRepositoryImpl implements CompletedOrderDetailsRepository {
  CompletedOrderDetailsRepositoryImpl({required CompletedOrderDetailsRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  final CompletedOrderDetailsRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, CompletedOrderDetailsEntity>> getCompletedOrderDetails(String orderId) async {
    try {
      final result = await _remoteDataSource.getCompletedOrderDetails(orderId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(NetworkFailure(e.toString()));
    }
  }
}