import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/completed_order_details_entity.dart';
import '../../domain/usecases/get_completed_order_details_use_case.dart';

part 'completed_order_details_state.dart';

class CompletedOrderDetailsCubit extends Cubit<CompletedOrderDetailsState> {
  final GetCompletedOrderDetailsUseCase _getCompletedOrderDetailsUseCase;

  CompletedOrderDetailsCubit(this._getCompletedOrderDetailsUseCase)
      : super(const CompletedOrderDetailsState.initial());

  Future<void> loadCompletedOrderDetails(String orderId) async {
    emit(state.copyWith(status: CompletedOrderDetailsStatus.loading));

    final result = await _getCompletedOrderDetailsUseCase(orderId);

    if (isClosed) return;
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: CompletedOrderDetailsStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (orderDetails) => emit(
        state.copyWith(
          status: CompletedOrderDetailsStatus.success,
          orderDetails: orderDetails,
        ),
      ),
    );
  }
}