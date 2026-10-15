import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/order_details_entity.dart';
import '../repositories/order_details_repository.dart';

class GetOrderDetailsUseCase {
  final OrderDetailsRepository _repository;

  GetOrderDetailsUseCase(this._repository);

  Future<Either<Failure, OrderDetailsEntity>> call(String orderId) {
    return _repository.getOrderDetails(orderId);
  }
}