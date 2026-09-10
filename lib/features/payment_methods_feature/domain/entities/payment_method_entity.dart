import 'package:equatable/equatable.dart';

class PaymentMethodEntity extends Equatable {
  final String id;
  final String title;
  final String? subtitle;

  const PaymentMethodEntity({
    required this.id,
    required this.title,
    this.subtitle,
  });

  @override
  List<Object?> get props => [id, title, subtitle];
}
