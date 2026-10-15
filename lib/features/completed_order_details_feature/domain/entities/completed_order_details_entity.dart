import 'package:equatable/equatable.dart';

class CompletedOrderProductEntity extends Equatable {
  final String title;
  final String subtitle;
  final String price;
  final String imageUrl;

  const CompletedOrderProductEntity({
    required this.title,
    required this.subtitle,
    required this.price,
    required this.imageUrl,
  });

  @override
  List<Object?> get props => [title, subtitle, price, imageUrl];
}

class CompletedOrderDeliveryAddressEntity extends Equatable {
  final String name;
  final String address;
  final String phone;

  const CompletedOrderDeliveryAddressEntity({
    required this.name,
    required this.address,
    required this.phone,
  });

  @override
  List<Object?> get props => [name, address, phone];
}

class CompletedOrderDetailsEntity extends Equatable {
  final String orderNumber;
  final String orderDate;
  final String statusText;
  final List<CompletedOrderProductEntity> products;
  final CompletedOrderDeliveryAddressEntity deliveryAddress;
  final String subtotal;
  final String deliveryFee;

  const CompletedOrderDetailsEntity({
    required this.orderNumber,
    required this.orderDate,
    required this.statusText,
    required this.products,
    required this.deliveryAddress,
    required this.subtotal,
    required this.deliveryFee,
  });

  @override
  List<Object?> get props => [
        orderNumber,
        orderDate,
        statusText,
        products,
        deliveryAddress,
        subtotal,
        deliveryFee,
      ];
}