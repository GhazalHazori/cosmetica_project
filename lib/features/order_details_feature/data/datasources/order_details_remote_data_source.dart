import 'package:flutter/material.dart';

import '../../domain/entities/order_details_entity.dart';

abstract class OrderDetailsRemoteDataSource {
  Future<OrderDetailsEntity> getOrderDetails(String orderId);
}

class OrderDetailsRemoteDataSourceImpl implements OrderDetailsRemoteDataSource {
  @override
  Future<OrderDetailsEntity> getOrderDetails(String orderId) async {
    return const OrderDetailsEntity(
      orderNumber: '892341#',
      orderDate: '14 مايو 2024',
      statusText: 'جاري التوصيل',
      statusIcon: Icons.local_shipping_outlined,
      products: [
        OrderProductEntity(
          title: 'سيروم فيتامين سي المطور',
          subtitle: 'الحجم: 50 مل',
          price: '240 ل.س',
          quantity: 'الكمية: 1',
          imageUrl: 'assets/images/category_image.jpg',
        ),
        OrderProductEntity(
          title: 'كريم الترطيب العميق',
          subtitle: 'النوع: للبشرة الجافة',
          price: '185 ل.س',
          quantity: 'الكمية: 1',
          imageUrl: 'assets/images/category_image.jpg',
        ),
      ],
      deliveryAddress: DeliveryAddressEntity(
        name: 'سارة أحمد',
        address: 'المنطقة الوسطى، الرياض\nحي الملقا، شارع الأمير محمد بن سعد',
        phone: ' 50 123 4567 +966',
      ),
      subtotal: '425 ل.س',
      deliveryFee: '25 ل.س',
      total: '450 ر.س',
    );
  }
}