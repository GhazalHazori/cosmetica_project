import 'package:flutter/material.dart';

import '../../../payment_methods_feature/presentation/pages/payment_methods_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final List<_CartItem> _cartItems = [
    _CartItem(
      title: 'عطر ديور جادور',
      details: 'الحجم: 100 مل | اللون: ذهبي',
      price: 950,
      imageColor: Color(0xFFE8DCC4),
      imagePath: 'assets/images/favorite_image.jpg',
    ),
    _CartItem(
      title: 'أحمر شفاه شانيل',
      details: 'الدرجة: 440 كاسيا',
      price: 420,
      quantity: 2,
      imageColor: Color(0xFFF3C5C5),
      imagePath: 'assets/images/category_image.jpg',
    ),
  ];

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _governorateController = TextEditingController();
  final _cityController = TextEditingController();
  final _regionController = TextEditingController();
  final _deliveryCenterController = TextEditingController();
  final _couponController = TextEditingController();

  bool _confirmData = false;
  bool _couponApplied = false;

  double get _subtotal =>
      _cartItems.fold(0, (total, item) => total + item.price * item.quantity);

  double get _tax => _subtotal * 0.15;

  double get _total => _subtotal + _tax;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _governorateController.dispose();
    _cityController.dispose();
    _regionController.dispose();
    _deliveryCenterController.dispose();
    _couponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          tooltip: 'رجوع',
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () {},
        ),
        title: const Text(
          'سلة التسوق',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'المزيد',
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: DefaultTextStyle(
          style: const TextStyle(color: Colors.black, fontFamily: 'Almarai'),
          child: IconTheme(
            data: const IconThemeData(color: Colors.black),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_cartItems.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 60, bottom: 40),
                        child: Text('السلة فارغة'),
                      ),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _cartItems.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (_, index) => _buildCartItemCard(index),
                    ),
                  const SizedBox(height: 24),
                  const Text(
                    'معلومات الشحن',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  _buildShippingInfoCard(),
                  const SizedBox(height: 24),
                  const Text(
                    'هل لديك رمز خصم؟',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: TextField(
                            controller: _couponController,
                            decoration: _inputDecoration(
                              'أدخل رمز القسيمة',
                              Icons.local_offer_outlined,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        height: 48,
                        width: 90,
                        child: ElevatedButton(
                          onPressed:
                              () => setState(
                                () =>
                                    _couponApplied =
                                        _couponController.text
                                            .trim()
                                            .isNotEmpty,
                              ),
                          style: _blackButtonStyle,
                          child: const Text(
                            'تطبيق',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Almarai',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (_couponApplied)
                    const Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: Text(
                        'تم تطبيق رمز الخصم',
                        style: TextStyle(color: Colors.green, fontSize: 12),
                      ),
                    ),
                  const SizedBox(height: 24),
                  _buildSummaryCard(),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                    onPressed:
                        _cartItems.isEmpty || !_confirmData
                            ? null
                            : () {
                                Navigator.pushNamed(
                                  context,
                                  PaymentMethodsScreen.routeName,
                                );
                              },
                      style: _blackButtonStyle,
                      child: const Text(
                        'إتمام عملية الشراء',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Almarai',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static final _blackButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: Colors.black,
    foregroundColor: Colors.white,
    disabledBackgroundColor: Colors.black26,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
    elevation: 0,
  );

  Widget _buildCartItemCard(int index) {
    final item = _cartItems[index];
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 1.2),
      ),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                       
                        Text(
                          item.title,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ), IconButton(
                          tooltip: 'حذف المنتج',
                          onPressed:
                              () => setState(() => _cartItems.removeAt(index)),
                          icon: const Icon(Icons.close, size: 20),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        item.details,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                       
                        Container(
                          height: 32,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                          ),
                          child: Row(
                            children: [
                                                         _quantityButton('-', () {
                                if (item.quantity > 1) {
                                  setState(() => item.quantity--);
                                }
                              }),
                              Text(
                                '${item.quantity}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                                 _quantityButton(
                                '+',
                                () => setState(() => item.quantity++),
                              ),
                            ],
                          ),
                        ),
                         Text(
                          '${item.price * item.quantity} ر.س',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            _buildProductImage(item),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage(_CartItem item) {
    return SizedBox(
      width: 100,
      height: 100,
      child: Image.asset(
        item.imagePath,
        fit: BoxFit.cover,
        errorBuilder:
            (_, __, ___) => ColoredBox(
              color: item.imageColor,
              child: const Icon(
                Icons.shopping_bag_outlined,
                size: 48,
                color: Colors.white70,
              ),
            ),
      ),
    );
  }

  Widget _quantityButton(String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Text(
          label,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildShippingInfoCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                'assets/images/flix_post.png',
                width: 86,
                height: 32,
                fit: BoxFit.contain,
              ),
              SizedBox(width: 8),
            ],
          ),
          const SizedBox(height: 12),
          _buildFormField(
            'اسم المستلم الثلاثي',
            _nameController,
            'أدخل الاسم الكامل',
          ),
          _buildFormField(
            'رقم الجوال',
            _phoneController,
            '05xxxxxxxx',
            textDirection: TextDirection.ltr,
          ),
          Row(
            children: [
              Expanded(
                child: _buildFormField(
                  'المحافظة',
                  _governorateController,
                  'المحافظة',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildFormField('المدينة', _cityController, 'المدينة'),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: _buildFormField('المنطقة', _regionController, 'المنطقة'),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildFormField(
                  'مركز التسليم',
                  _deliveryCenterController,
                  'أقرب مركز',
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'تأكيد البيانات',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
              Transform.scale(
                scale: 0.8,
                child: Switch(
                  value: _confirmData,
                  activeThumbColor: Colors.black,
                  onChanged: (value) => setState(() => _confirmData = value),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFormField(
    String label,
    TextEditingController controller,
    String hint, {
    TextDirection? textDirection,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              label,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 40,
            child: TextField(
              controller: controller,
              textDirection: textDirection,
              
              style: const TextStyle(fontSize: 13),
              decoration: _inputDecoration(hint, null, textDirection),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(
    String hint,
    IconData? icon, [
    TextDirection? textDirection,
  ]) {
    return InputDecoration(
      hintText: hint,
      hintTextDirection: textDirection,
      fillColor: Colors.white,
      filled: true,
      prefixIcon:
          icon == null ? null : Icon(icon, color: Colors.grey, size: 20),
      hintStyle: const TextStyle(color: Colors.black26, fontSize: 12),
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: Colors.black, width: 1),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: Colors.black, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 1.2),
      ),
      child: Column(
        children: [
          _buildSummaryRow(
            'المجموع الفرعي',
            '${_subtotal.toStringAsFixed(0)} ر.س',
          ),
          const SizedBox(height: 8),
          _buildSummaryRow('الشحن', 'مجاني'),
          const SizedBox(height: 8),
          _buildSummaryRow('الضريبة (15%)', '${_tax.toStringAsFixed(1)} ر.س'),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(color: Colors.black, height: 1),
          ),
          _buildSummaryRow(
            'الإجمالي',
            '${_total.toStringAsFixed(1)} ر.س',
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    final size = isTotal ? 16.0 : 13.0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: size,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? Colors.black : Colors.grey.shade700,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: size,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}

class _CartItem {
  final String title;
  final String details;
  final int price;
  int quantity;
  final Color imageColor;
  final String imagePath;

  _CartItem({
    required this.title,
    required this.details,
    required this.price,
    this.quantity = 1,
    required this.imageColor,
    required this.imagePath,
  });
}
