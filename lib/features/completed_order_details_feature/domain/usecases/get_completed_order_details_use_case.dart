import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/completed_order_details_entity.dart';
import '../repositories/completed_order_details_repository.dart';

class GetCompletedOrderDetailsUseCase {
  final CompletedOrderDetailsRepository _repository;

  GetCompletedOrderDetailsUseCase(this._repository);

  Future<Either<Failure, CompletedOrderDetailsEntity>> call(String orderId) {
    return _repository.getCompletedOrderDetails(orderId);
  }
}