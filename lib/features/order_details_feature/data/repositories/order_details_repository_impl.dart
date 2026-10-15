import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/order_details_entity.dart';
import '../../domain/repositories/order_details_repository.dart';
import '../datasources/order_details_remote_data_source.dart';

class OrderDetailsRepositoryImpl implements OrderDetailsRepository {
  OrderDetailsRepositoryImpl({required OrderDetailsRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  final OrderDetailsRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, OrderDetailsEntity>> getOrderDetails(String orderId) async {
    try {
      final result = await _remoteDataSource.getOrderDetails(orderId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(NetworkFailure(e.toString()));
    }
  }
}