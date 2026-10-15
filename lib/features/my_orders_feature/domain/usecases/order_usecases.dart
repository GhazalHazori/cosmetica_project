import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/order_entity.dart';
import '../repositories/order_repository.dart';

class GetCurrentOrdersUseCase {
  final OrderRepository _repository;

  GetCurrentOrdersUseCase(this._repository);

  Future<Either<Failure, List<OrderEntity>>> call() {
    return _repository.getCurrentOrders();
  }
}

class GetPastOrdersUseCase {
  final OrderRepository _repository;

  GetPastOrdersUseCase(this._repository);

  Future<Either<Failure, List<OrderEntity>>> call() {
    return _repository.getPastOrders();
  }
}