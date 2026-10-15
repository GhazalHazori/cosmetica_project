import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../di/injection_container.dart';
import '../cubit/my_orders_cubit.dart';
import '../widgets/order_card.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  static const String routeName = '/my-orders';

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);
  }

  void _handleTabChange() {
    if (!_tabController.indexIsChanging) {
      context.read<MyOrdersCubit>().selectTab(_tabController.index);
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<MyOrdersCubit>(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FAFB),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'طلباتي',
            style: TextStyle(
              color: Colors.black,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'Almarai'
            ),
          ),
          leading: SizedBox.shrink(),
          actions:[ IconButton(
            icon: const Icon(Icons.arrow_forward, color: Colors.black),
            onPressed: () => Navigator.maybePop(context),
          )],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48),
            child: Column(
              children: [
                Container(
                  color: Colors.white,
                  child: TabBar(
                    controller: _tabController,
                    indicatorColor: Colors.black,
                    indicatorWeight: 2,
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.grey[400],
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                        fontFamily: 'Almarai',
                      fontSize: 15,
                    ),
                    tabs: const [
                      Tab(text: 'طلبات جارية'),
                      Tab(text: 'طلبات سابقة'),
                    ],
                  ),
                ),
                const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
              ],
            ),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            // Current orders
            BlocBuilder<MyOrdersCubit, MyOrdersState>(
              builder: (context, state) {
                if (state.status == MyOrdersStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state.currentOrders.isEmpty) {
                  return const Center(
                    child: Text(
                      'لا توجد طلبات جارية',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  );
                }
                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: state.currentOrders
                      .map((order) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: OrderCard(order: order),
                          ))
                      .toList(),
                );
              },
            ),
            // Past orders
            BlocBuilder<MyOrdersCubit, MyOrdersState>(
              builder: (context, state) {
                if (state.pastOrders.isEmpty) {
                  return const Center(
                    child: Text(
                      'لا توجد طلبات سابقة',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  );
                }
                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: state.pastOrders
                      .map((order) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: OrderCard(order: order),
                          ))
                      .toList(),
                );
              },
            ),
          ],
        ),
      
      ),
    );
  }
}