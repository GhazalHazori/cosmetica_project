import 'package:flutter/material.dart';

import '../../domain/entities/order_entity.dart';

class OrderItemModel extends OrderItemEntity {
  const OrderItemModel({
    required super.imageUrl,
    super.remainingCount,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      imageUrl: json['imageUrl'] as String,
      remainingCount: json['remainingCount'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'imageUrl': imageUrl,
      if (remainingCount != null) 'remainingCount': remainingCount,
    };
  }
}

class OrderModel extends OrderEntity {
  const OrderModel({
    required super.id,
    required super.statusText,
    required super.statusIcon,
    required super.orderDate,
    required super.orderNumber,
    required super.totalPrice,
    required super.items,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final itemsJson = json['items'] as List<dynamic>?;
    return OrderModel(
      id: json['id'] as String,
      statusText: json['statusText'] as String,
      statusIcon: _iconFromString(json['statusIcon'] as String),
      orderDate: json['orderDate'] as String,
      orderNumber: json['orderNumber'] as String,
      totalPrice: json['totalPrice'] as String,
      items: itemsJson != null
          ? itemsJson
              .map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : const [],
    );
  }

  static IconData _iconFromString(String iconName) {
    switch (iconName) {
      case 'assignment_outlined':
        return Icons.assignment_outlined;
      case 'local_shipping_outlined':
        return Icons.local_shipping_outlined;
      default:
        return Icons.assignment_outlined;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'statusText': statusText,
      'statusIcon': _iconToString(statusIcon),
      'orderDate': orderDate,
      'orderNumber': orderNumber,
      'totalPrice': totalPrice,
      'items': items.map((e) => (e as OrderItemModel).toJson()).toList(),
    };
  }

  static String _iconToString(IconData icon) {
    if (icon == Icons.local_shipping_outlined) return 'local_shipping_outlined';
    return 'assignment_outlined';
  }
}