import '../../domain/entities/order_details_entity.dart';
import 'package:flutter/material.dart';

class OrderProductModel extends OrderProductEntity {
  const OrderProductModel({
    required super.title,
    required super.subtitle,
    required super.price,
    required super.quantity,
    required super.imageUrl,
  });

  factory OrderProductModel.fromJson(Map<String, dynamic> json) {
    return OrderProductModel(
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      price: json['price'] as String,
      quantity: json['quantity'] as String,
      imageUrl: json['imageUrl'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subtitle': subtitle,
      'price': price,
      'quantity': quantity,
      'imageUrl': imageUrl,
    };
  }
}

class DeliveryAddressModel extends DeliveryAddressEntity {
  const DeliveryAddressModel({
    required super.name,
    required super.address,
    required super.phone,
  });

  factory DeliveryAddressModel.fromJson(Map<String, dynamic> json) {
    return DeliveryAddressModel(
      name: json['name'] as String,
      address: json['address'] as String,
      phone: json['phone'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'phone': phone,
    };
  }
}

class OrderDetailsModel extends OrderDetailsEntity {
  const OrderDetailsModel({
    required super.orderNumber,
    required super.orderDate,
    required super.statusText,
    required super.statusIcon,
    required super.products,
    required super.deliveryAddress,
    required super.subtotal,
    required super.deliveryFee,
    required super.total,
  });

  factory OrderDetailsModel.fromJson(Map<String, dynamic> json) {
    final productsJson = json['products'] as List<dynamic>?;
    final addressJson = json['deliveryAddress'] as Map<String, dynamic>?;

    return OrderDetailsModel(
      orderNumber: json['orderNumber'] as String,
      orderDate: json['orderDate'] as String,
      statusText: json['statusText'] as String,
      statusIcon: _iconFromString(json['statusIcon'] as String),
      products: productsJson != null
          ? productsJson
              .map((e) => OrderProductModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : const [],
      deliveryAddress: addressJson != null
          ? DeliveryAddressModel.fromJson(addressJson)
          : const DeliveryAddressModel(name: '', address: '', phone: ''),
      subtotal: json['subtotal'] as String,
      deliveryFee: json['deliveryFee'] as String,
      total: json['total'] as String,
    );
  }

  static IconData _iconFromString(String iconName) {
    switch (iconName) {
      case 'local_shipping_outlined':
        return Icons.local_shipping_outlined;
      case 'assignment_outlined':
        return Icons.assignment_outlined;
      default:
        return Icons.assignment_outlined;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'orderNumber': orderNumber,
      'orderDate': orderDate,
      'statusText': statusText,
      'statusIcon': _iconToString(statusIcon),
      'products': products.map((e) => (e as OrderProductModel).toJson()).toList(),
      'deliveryAddress': (deliveryAddress as DeliveryAddressModel).toJson(),
      'subtotal': subtotal,
      'deliveryFee': deliveryFee,
      'total': total,
    };
  }

  static String _iconToString(IconData icon) {
    if (icon == Icons.local_shipping_outlined) return 'local_shipping_outlined';
    return 'assignment_outlined';
  }
}