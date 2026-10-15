import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/completed_order_details_entity.dart';

abstract class CompletedOrderDetailsRepository {
  Future<Either<Failure, CompletedOrderDetailsEntity>> getCompletedOrderDetails(String orderId);
}