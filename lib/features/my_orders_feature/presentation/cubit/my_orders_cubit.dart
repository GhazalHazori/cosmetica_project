import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/order_entity.dart';
import '../../domain/usecases/order_usecases.dart';

part 'my_orders_state.dart';

class MyOrdersCubit extends Cubit<MyOrdersState> {
  final GetCurrentOrdersUseCase _getCurrentOrdersUseCase;
  final GetPastOrdersUseCase _getPastOrdersUseCase;

  MyOrdersCubit(
    this._getCurrentOrdersUseCase,
    this._getPastOrdersUseCase,
  ) : super(const MyOrdersState.initial()) {
    loadOrders();
  }

  Future<void> loadOrders() async {
    emit(state.copyWith(status: MyOrdersStatus.loading));

    final currentResult = await _getCurrentOrdersUseCase();
    final pastResult = await _getPastOrdersUseCase();

    if (isClosed) return;

    final currentOrders = currentResult.fold(
      (failure) => <OrderEntity>[],
      (orders) => orders,
    );

    final pastOrders = pastResult.fold(
      (failure) => <OrderEntity>[],
      (orders) => orders,
    );

    emit(
      state.copyWith(
        status: MyOrdersStatus.success,
        currentOrders: currentOrders,
        pastOrders: pastOrders,
      ),
    );
  }

  void selectTab(int index) {
    emit(state.copyWith(selectedTab: index));
  }
}