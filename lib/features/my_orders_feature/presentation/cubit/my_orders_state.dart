part of 'my_orders_cubit.dart';

enum MyOrdersStatus { initial, loading, success, failure }

class MyOrdersState extends Equatable {
  final MyOrdersStatus status;
  final List<OrderEntity> currentOrders;
  final List<OrderEntity> pastOrders;
  final String? errorMessage;
  final int selectedTab;

  const MyOrdersState({
    required this.status,
    required this.currentOrders,
    required this.pastOrders,
    this.errorMessage,
    required this.selectedTab,
  });

  const MyOrdersState.initial()
      : status = MyOrdersStatus.initial,
        currentOrders = const [],
        pastOrders = const [],
        errorMessage = null,
        selectedTab = 0;

  MyOrdersState copyWith({
    MyOrdersStatus? status,
    List<OrderEntity>? currentOrders,
    List<OrderEntity>? pastOrders,
    String? errorMessage,
    int? selectedTab,
  }) {
    return MyOrdersState(
      status: status ?? this.status,
      currentOrders: currentOrders ?? this.currentOrders,
      pastOrders: pastOrders ?? this.pastOrders,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedTab: selectedTab ?? this.selectedTab,
    );
  }

  @override
  List<Object?> get props => [status, currentOrders, pastOrders, errorMessage, selectedTab];
}