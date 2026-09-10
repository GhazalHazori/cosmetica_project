import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/payment_method_entity.dart';
import '../repositories/payment_method_repository.dart';

class GetPaymentMethodsUseCase {
  final PaymentMethodRepository _repository;

  GetPaymentMethodsUseCase(this._repository);

  Future<Either<Failure, List<PaymentMethodEntity>>> call() {
    return _repository.getPaymentMethods();
  }
}
