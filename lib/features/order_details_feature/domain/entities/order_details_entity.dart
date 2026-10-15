import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class OrderProductEntity extends Equatable {
  final String title;
  final String subtitle;
  final String price;
  final String quantity;
  final String imageUrl;

  const OrderProductEntity({
    required this.title,
    required this.subtitle,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });

  @override
  List<Object?> get props => [title, subtitle, price, quantity, imageUrl];
}

class DeliveryAddressEntity extends Equatable {
  final String name;
  final String address;
  final String phone;

  const DeliveryAddressEntity({
    required this.name,
    required this.address,
    required this.phone,
  });

  @override
  List<Object?> get props => [name, address, phone];
}

class OrderDetailsEntity extends Equatable {
  final String orderNumber;
  final String orderDate;
  final String statusText;
  final IconData statusIcon;
  final List<OrderProductEntity> products;
  final DeliveryAddressEntity deliveryAddress;
  final String subtotal;
  final String deliveryFee;
  final String total;

  const OrderDetailsEntity({
    required this.orderNumber,
    required this.orderDate,
    required this.statusText,
    required this.statusIcon,
    required this.products,
    required this.deliveryAddress,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
  });

  @override
  List<Object?> get props => [
        orderNumber,
        orderDate,
        statusText,
        statusIcon,
        products,
        deliveryAddress,
        subtotal,
        deliveryFee,
        total,
      ];
}