import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/payment_method_entity.dart';

abstract class PaymentMethodRepository {
  Future<Either<Failure, List<PaymentMethodEntity>>> getPaymentMethods();
}
