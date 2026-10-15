part of 'completed_order_details_cubit.dart';

enum CompletedOrderDetailsStatus { initial, loading, success, failure }

class CompletedOrderDetailsState extends Equatable {
  final CompletedOrderDetailsStatus status;
  final CompletedOrderDetailsEntity? orderDetails;
  final String? errorMessage;

  const CompletedOrderDetailsState({
    required this.status,
    this.orderDetails,
    this.errorMessage,
  });

  const CompletedOrderDetailsState.initial()
      : status = CompletedOrderDetailsStatus.initial,
        orderDetails = null,
        errorMessage = null;

  CompletedOrderDetailsState copyWith({
    CompletedOrderDetailsStatus? status,
    CompletedOrderDetailsEntity? orderDetails,
    String? errorMessage,
  }) {
    return CompletedOrderDetailsState(
      status: status ?? this.status,
      orderDetails: orderDetails ?? this.orderDetails,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, orderDetails, errorMessage];
}