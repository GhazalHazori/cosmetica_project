import 'package:flutter/material.dart';

import '../../../completed_order_details_feature/presentation/pages/completed_order_details_screen.dart';
import '../../../order_details_feature/presentation/pages/order_details_screen.dart';
import '../../domain/entities/order_entity.dart';
import '../../../../core/theme/app_spacing.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({
    super.key,
    required this.order,
  });

  final OrderEntity order;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: status badge and order date/number
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               // Order date and number
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'تاريخ الطلب: ${order.orderDate}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'رقم الطلب ${order.orderNumber}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              // Status badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    
                    Icon(order.statusIcon, size: 16, color: Colors.black),
                    const SizedBox(width: 4),
                    Text(
                      order.statusText,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
             
            ],
          ),
          const SizedBox(height: 16),

          // Product images
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ...order.items.map(
                (item) => Container(
                  width: 65,
                  height: 65,
                  margin: const EdgeInsets.only(left: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F7),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: item.remainingCount != null
                        ? Center(
                            child: Text(
                              item.remainingCount!,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                  fontFamily: 'Almarai'
                              ),
                            ),
                          )
                        : Image.asset(
                            item.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.image, color: Colors.grey);
                            },
                          ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Track button and total price
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
                // Total price
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'إجمالي الطلب',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        order.totalPrice,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                            fontFamily: 'Almarai'
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'ر.س',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                            fontFamily: 'Almarai'
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // Track order button
              ElevatedButton(
                onPressed: () {
                  final isCompleted = order.statusText == 'خرج للتوصيل' || 
                                      order.statusText == 'تم التوصيل';
                  Navigator.pushNamed(
                    context,
                    isCompleted
                        ? CompletedOrderDetailsScreen.routeName
                        : OrderDetailsScreen.routeName,
                    arguments: order.id,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                ),
                child: const Text(
                  'تتبع الطلب',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                      fontFamily: 'Almarai'
                  ),
                ),
              ),
            
            ],
          ),
        ],
      ),
    );
  }
}