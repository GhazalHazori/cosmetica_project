import '../../domain/entities/completed_order_details_entity.dart';

class CompletedOrderProductModel extends CompletedOrderProductEntity {
  const CompletedOrderProductModel({
    required super.title,
    required super.subtitle,
    required super.price,
    required super.imageUrl,
  });

  factory CompletedOrderProductModel.fromJson(Map<String, dynamic> json) {
    return CompletedOrderProductModel(
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      price: json['price'] as String,
      imageUrl: json['imageUrl'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subtitle': subtitle,
      'price': price,
      'imageUrl': imageUrl,
    };
  }
}

class CompletedOrderDeliveryAddressModel extends CompletedOrderDeliveryAddressEntity {
  const CompletedOrderDeliveryAddressModel({
    required super.name,
    required super.address,
    required super.phone,
  });

  factory CompletedOrderDeliveryAddressModel.fromJson(Map<String, dynamic> json) {
    return CompletedOrderDeliveryAddressModel(
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

class CompletedOrderDetailsModel extends CompletedOrderDetailsEntity {
  const CompletedOrderDetailsModel({
    required super.orderNumber,
    required super.orderDate,
    required super.statusText,
    required super.products,
    required super.deliveryAddress,
    required super.subtotal,
    required super.deliveryFee,
  });

  factory CompletedOrderDetailsModel.fromJson(Map<String, dynamic> json) {
    final productsJson = json['products'] as List<dynamic>?;
    final addressJson = json['deliveryAddress'] as Map<String, dynamic>?;

    return CompletedOrderDetailsModel(
      orderNumber: json['orderNumber'] as String,
      orderDate: json['orderDate'] as String,
      statusText: json['statusText'] as String,
      products: productsJson != null
          ? productsJson
              .map((e) => CompletedOrderProductModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : const [],
      deliveryAddress: addressJson != null
          ? CompletedOrderDeliveryAddressModel.fromJson(addressJson)
          : const CompletedOrderDeliveryAddressModel(name: '', address: '', phone: ''),
      subtotal: json['subtotal'] as String,
      deliveryFee: json['deliveryFee'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderNumber': orderNumber,
      'orderDate': orderDate,
      'statusText': statusText,
      'products': products.map((e) => (e as CompletedOrderProductModel).toJson()).toList(),
      'deliveryAddress': (deliveryAddress as CompletedOrderDeliveryAddressModel).toJson(),
      'subtotal': subtotal,
      'deliveryFee': deliveryFee,
    };
  }
}