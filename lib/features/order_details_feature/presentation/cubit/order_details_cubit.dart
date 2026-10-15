import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/order_details_entity.dart';
import '../../domain/usecases/get_order_details_use_case.dart';

part 'order_details_state.dart';

class OrderDetailsCubit extends Cubit<OrderDetailsState> {
  final GetOrderDetailsUseCase _getOrderDetailsUseCase;

  OrderDetailsCubit(this._getOrderDetailsUseCase) : super(const OrderDetailsState.initial());

  Future<void> loadOrderDetails(String orderId) async {
    emit(state.copyWith(status: OrderDetailsStatus.loading));

    final result = await _getOrderDetailsUseCase(orderId);

    if (isClosed) return;
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: OrderDetailsStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (orderDetails) => emit(
        state.copyWith(
          status: OrderDetailsStatus.success,
          orderDetails: orderDetails,
        ),
      ),
    );
  }
}