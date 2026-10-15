import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../di/injection_container.dart';
import '../../../submit_complaint_feature/presentation/pages/submit_complaint_screen.dart';
import '../cubit/completed_order_details_cubit.dart';
import '../widgets/completed_order_details_widgets.dart';

class CompletedOrderDetailsScreen extends StatefulWidget {
  const CompletedOrderDetailsScreen({super.key});

  static const String routeName = '/completed-order-details';

  @override
  State<CompletedOrderDetailsScreen> createState() => _CompletedOrderDetailsScreenState();
}

class _CompletedOrderDetailsScreenState extends State<CompletedOrderDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    // استخراج رقم الطلب بأمان داخل build
    final orderId = ModalRoute.of(context)?.settings.arguments as String? ?? '';

    return BlocProvider<CompletedOrderDetailsCubit>(
      create: (context) {
        final cubit = sl<CompletedOrderDetailsCubit>();
        if (orderId.isNotEmpty) {
          cubit.loadCompletedOrderDetails(orderId);
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
        body: BlocBuilder<CompletedOrderDetailsCubit, CompletedOrderDetailsState>(
          builder: (context, state) {
            if (state.status == CompletedOrderDetailsStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.status == CompletedOrderDetailsStatus.failure) {
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
                  OrderDateNumberCard(
                    orderDate: order.orderDate,
                    orderNumber: order.orderNumber,
                  ),
                  const SizedBox(height: 12),
                  OrderStatusBadge(statusText: order.statusText),
                  const SizedBox(height: 24),
                  const Text(
                    'المنتجات',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                ...order.products.map(
                    (product) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: ProductReviewCard(
                        product: product,
                        onSubmitReview:() {}
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
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
                  const SizedBox(height: 24),
                  OrderAgainButton(onPressed: () {}),
                  const SizedBox(height: 12),
                  SubmitComplaintButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        SubmitComplaintScreen.routeName,
                      );
                    },
                  ),
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