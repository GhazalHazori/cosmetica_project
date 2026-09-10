import '../models/payment_method_model.dart';

abstract class PaymentMethodRemoteDataSource {
  Future<List<PaymentMethodModel>> getPaymentMethods();
}

class PaymentMethodRemoteDataSourceImpl
    implements PaymentMethodRemoteDataSource {
  @override
  Future<List<PaymentMethodModel>> getPaymentMethods() async {
    return [
      PaymentMethodModel(
        id: 'visa',
        title: 'Visa Platinum',
        subtitle: '.... .... .... 4242',
      ),
      PaymentMethodModel(
        id: 'mastercard',
        title: 'Mastercard World',
        subtitle: '.... .... .... 5555',
      ),
      PaymentMethodModel(
        id: 'apple_pay',
        title: 'Apple Pay',
      ),
      PaymentMethodModel(
        id: 'cod',
        title: 'الدفع عند الاستلام',
      ),
    ];
  }
}
