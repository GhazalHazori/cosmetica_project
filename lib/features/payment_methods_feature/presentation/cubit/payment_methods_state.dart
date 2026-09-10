part of 'payment_methods_cubit.dart';

enum PaymentMethodsStatus { initial, loading, success, failure }

class PaymentMethodsState extends Equatable {
  final PaymentMethodsStatus status;
  final List<PaymentMethodEntity> methods;
  final String? selectedMethod;
  final String? errorMessage;

  const PaymentMethodsState({
    required this.status,
    required this.methods,
    required this.selectedMethod,
    this.errorMessage,
  });

  const PaymentMethodsState.initial()
      : status = PaymentMethodsStatus.initial,
        methods = const [],
        selectedMethod = 'visa',
        errorMessage = null;

  PaymentMethodsState copyWith({
    PaymentMethodsStatus? status,
    List<PaymentMethodEntity>? methods,
    String? selectedMethod,
    String? errorMessage,
  }) {
    return PaymentMethodsState(
      status: status ?? this.status,
      methods: methods ?? this.methods,
      selectedMethod: selectedMethod ?? this.selectedMethod,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, methods, selectedMethod, errorMessage];
}
