import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class OrderItemEntity extends Equatable {
  final String imageUrl;
  final String? remainingCount;

  const OrderItemEntity({
    required this.imageUrl,
    this.remainingCount,
  });

  @override
  List<Object?> get props => [imageUrl, remainingCount];
}

class OrderEntity extends Equatable {
  final String id;
  final String statusText;
  final IconData statusIcon;
  final String orderDate;
  final String orderNumber;
  final String totalPrice;
  final List<OrderItemEntity> items;

  const OrderEntity({
    required this.id,
    required this.statusText,
    required this.statusIcon,
    required this.orderDate,
    required this.orderNumber,
    required this.totalPrice,
    required this.items,
  });

  @override
  List<Object?> get props => [
        id,
        statusText,
        statusIcon,
        orderDate,
        orderNumber,
        totalPrice,
        items,
      ];
}