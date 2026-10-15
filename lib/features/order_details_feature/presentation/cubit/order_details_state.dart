part of 'order_details_cubit.dart';

enum OrderDetailsStatus { initial, loading, success, failure }

class OrderDetailsState extends Equatable {
  final OrderDetailsStatus status;
  final OrderDetailsEntity? orderDetails;
  final String? errorMessage;

  const OrderDetailsState({
    required this.status,
    this.orderDetails,
    this.errorMessage,
  });

  const OrderDetailsState.initial()
      : status = OrderDetailsStatus.initial,
        orderDetails = null,
        errorMessage = null;

  OrderDetailsState copyWith({
    OrderDetailsStatus? status,
    OrderDetailsEntity? orderDetails,
    String? errorMessage,
  }) {
    return OrderDetailsState(
      status: status ?? this.status,
      orderDetails: orderDetails ?? this.orderDetails,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, orderDetails, errorMessage];
}