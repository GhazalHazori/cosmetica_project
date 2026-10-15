import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../di/injection_container.dart';
import '../cubit/order_details_cubit.dart';
import '../widgets/order_details_widgets.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({super.key});

  static const String routeName = '/order-details';

  @override
  Widget build(BuildContext context) {
    // استخراج رقم الطلب من الـ Routes
    final orderId = ModalRoute.of(context)?.settings.arguments as String? ?? '';

    return BlocProvider<OrderDetailsCubit>(
      create: (context) {
        final cubit = sl<OrderDetailsCubit>();
        if (orderId.isNotEmpty) {
          cubit.loadOrderDetails(orderId);
        }
        return cubit;
      },
      child: Scaffold(
       backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'تفاصيل الطلب',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: SizedBox.shrink(),
          actions:[ IconButton(
            icon: const Icon(Icons.arrow_forward, color: Colors.black),
            onPressed: () => Navigator.maybePop(context),
          ),]
        ),
        body: BlocBuilder<OrderDetailsCubit, OrderDetailsState>(
          builder: (context, state) {
            if (state.status == OrderDetailsStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.status == OrderDetailsStatus.failure) {
              return Center(
                child: Text(
                  state.errorMessage ?? 'حدث خطأ',
                  style: const TextStyle(color: Colors.grey, fontSize: 16),
                ),
              );
            }

            final order = state.orderDetails;
            if (order == null) {
              return const Center(child: Text('لا توجد بيانات'));
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Order number and date
                  Row(
                    children: [
                      Expanded(
                        child: InfoCard(
                          title: 'رقم الطلب',
                          value: order.orderNumber,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: InfoCard(
                          title: 'التاريخ',
                          value: order.orderDate,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // 2. Order status
                  OrderStatusCard(
                    icon: order.statusIcon,
                    statusText: order.statusText,
                  ),
                  const SizedBox(height: 24),

                  // 3. Products section
                  Text(
                    'المنتجات (${order.products.length})',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...order.products.map(
                    (product) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: ProductCard(product: product),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 4. Delivery address
                  const Text(
                    'عنوان التوصيل',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  DeliveryAddressCard(address: order.deliveryAddress),
                  const SizedBox(height: 24),

                  // 5. Payment summary
                  const Text(
                    'ملخص الدفع',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  PaymentSummaryRow(
                    label: 'المجموع الفرعي',
                    value: order.subtotal,
                  ),
                  const SizedBox(height: 8),
                  PaymentSummaryRow(
                    label: 'رسوم التوصيل',
                    value: order.deliveryFee,
                  ),
                  const SizedBox(height: 16),
                  PaymentSummaryRow(
                    label: 'الإجمالي',
                    value: order.total,
                    isTotal: true,
                  ),
                  const SizedBox(height: 24),

                  // 6. Cancel order button
                  CancelOrderButton(onPressed: () {}),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}