import 'package:flutter/material.dart';

import '../../domain/entities/order_entity.dart';

abstract class OrderRemoteDataSource {
  Future<List<OrderEntity>> getCurrentOrders();
  Future<List<OrderEntity>> getPastOrders();
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  @override
  Future<List<OrderEntity>> getCurrentOrders() async {
    return [
      OrderEntity(
        id: '1',
        statusText: 'قيد التنفيذ',
        statusIcon: Icons.assignment_outlined,
        orderDate: '14 مايو 2024',
        orderNumber: '892341#',
        totalPrice: '1,250',
        items: const [
          OrderItemEntity(imageUrl: 'assets/images/category_image.jpg'),
           OrderItemEntity(imageUrl: 'assets/images/favorite_image.jpg'),
          OrderItemEntity(imageUrl: 'assets/images/category_image.jpg', remainingCount: '+1'),
        ],
      ),
      OrderEntity(
        id: '2',
        statusText: 'خرج للتوصيل',
        statusIcon: Icons.local_shipping_outlined,
        orderDate: '12 مايو 2024',
        orderNumber: '892102#',
        totalPrice: '840',
        items: const [
          OrderItemEntity(imageUrl: 'assets/images/category_image.jpg'),
        ],
      ),
    ];
  }

  @override
  Future<List<OrderEntity>> getPastOrders() async {
    return [];
  }
}