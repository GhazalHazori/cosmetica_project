import '../../domain/entities/completed_order_details_entity.dart';

abstract class CompletedOrderDetailsRemoteDataSource {
  Future<CompletedOrderDetailsEntity> getCompletedOrderDetails(String orderId);
}

class CompletedOrderDetailsRemoteDataSourceImpl implements CompletedOrderDetailsRemoteDataSource {
  @override
  Future<CompletedOrderDetailsEntity> getCompletedOrderDetails(String orderId) async {
    return const CompletedOrderDetailsEntity(
      orderNumber: '#892341',
      orderDate: '14 مايو 2024',
      statusText: 'تم التوصيل',
      products: [
        CompletedOrderProductEntity(
          title: 'سيروم مرطب',
          subtitle: 'الحجم: 30 مل | الكمية: 1',
          price: '45.00 ر.س',
          imageUrl: 'assets/images/category_image.jpg',
        ),
        CompletedOrderProductEntity(
          title: 'كريم استعادة النضارة',
          subtitle: 'الحجم: 50 مل | الكمية: 1',
          price: '62.00 ر.س',
          imageUrl: 'assets/images/category_image.jpg',
        ),
      ],
      deliveryAddress: CompletedOrderDeliveryAddressEntity(
        name: 'سارة أحمد',
        address: 'دبي، الإمارات العربية المتحدة\nوسط المدينة، مساكن برج بارك\nمركز التوصيل: مركز دبي مول',
        phone: '+971 50 123 4567',
      ),
      subtotal: '107.00 ر.س',
      deliveryFee: '5.00 ر.س',
    );
  }
}