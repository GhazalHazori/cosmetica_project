import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/payment_method_entity.dart';
import '../../domain/usecases/get_payment_methods_use_case.dart';

part 'payment_methods_state.dart';

class PaymentMethodsCubit extends Cubit<PaymentMethodsState> {
  final GetPaymentMethodsUseCase _getPaymentMethodsUseCase;

  PaymentMethodsCubit(this._getPaymentMethodsUseCase)
      : super(const PaymentMethodsState.initial()) {
    loadPaymentMethods();
  }

  Future<void> loadPaymentMethods() async {
    emit(state.copyWith(status: PaymentMethodsStatus.loading));

    final result = await _getPaymentMethodsUseCase();

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: PaymentMethodsStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (methods) => emit(
        state.copyWith(
          status: PaymentMethodsStatus.success,
          methods: methods,
        ),
      ),
    );
  }

  void selectMethod(String id) {
    emit(state.copyWith(selectedMethod: id));
  }
}
