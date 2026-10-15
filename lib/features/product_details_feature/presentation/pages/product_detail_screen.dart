import 'package:flutter/material.dart';
import '../../domain/entities/product_detail_entity.dart';
import '../../../../core/theme/app_spacing.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key, required this.product});

  static const String routeName = '/product-detail';

  final ProductDetailEntity product;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int quantity = 1;
  int selectedSize = 0;
  int selectedColor = 0;

  static const colors = [
    ('عاجي', 0xFFFFF0E5),
    ('بيج مثالي', 0xFFFBE3D4),
    ('وردي', 0xFFFCDEDC),
    ('برونز', 0xFFE2A07E),
    ('طبيعي', 0xFFC85A17),
    ('وردي مفعم', 0xFFFCE4EC),
    ('خوخي', 0xFFFFB7B2),
    ('مرجاني', 0xFFE57373),
    ('أحمر', 0xFFD32F2F),
  ];

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Theme(
      // توحيد لون النص في الصفحة بأكملها إلى الأسود
      data: Theme.of(context).copyWith(
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Colors.black,
              displayColor: Colors.black,
            ),
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
              onPressed: () => Navigator.maybePop(context),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.favorite_border, color: Colors.black),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.share_outlined, color: Colors.black),
                onPressed: () {},
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // العنوان والبراند مع السعر
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'كوزمتيكا (COSMETICA)',
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            product.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      product.price,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                // التقييم
                Row(
                  children: [
                    ...List.generate(
                      5,
                      (index) => const Icon(Icons.star, color: Colors.black, size: 14),
                    ),
                    const SizedBox(width: 6),
                    Text('(١٢٤ تقييم)', style: TextStyle(color: Colors.grey.shade600, fontSize: 11)),
                  ],
                ),
                const SizedBox(height: 12),
                // شريط الشحن والعرض
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.local_shipping_outlined, color: Colors.black, size: 16),
                          SizedBox(width: 4),
                          Text('شحن مجاني', style: TextStyle(fontSize: 11, color: Colors.black)),
                        ],
                      ),
                      Row(
                        children: [
                          const Text('ينتهي العرض خلال: ', style: TextStyle(fontSize: 11, color: Colors.black)),
                          _buildTimerBox('02'),
                          const Text(' : ', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black)),
                          _buildTimerBox('45'),
                          const Text(' : ', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black)),
                          _buildTimerBox('10'),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // صورة المنتج
                Container(
                  height: 320,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(product.color.value),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.asset(
                      product.imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Center(
                        child: Icon(Icons.photo, size: 80, color: Colors.brown),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // خيارات الحجم
                _buildSizeOption(0, '٣٠ مل (الأساسي)', product.price, '٤٥٠ ر.س'),
                const SizedBox(height: 8),
                _buildSizeOption(1, '٥٠ مل', '٦٥٠ ر.س', null),
                const SizedBox(height: 16),
                // قائمة الألوان
                Text('اللون:', style: TextStyle(fontSize: 13, color: Colors.grey.shade700)),
                const SizedBox(height: 8),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 2.6,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: colors.length,
                  itemBuilder: (context, index) {
                    final isSelected = selectedColor == index;
                    return GestureDetector(
                      onTap: () => setState(() => selectedColor = index),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isSelected ? Colors.black : Colors.grey.shade300,
                            width: isSelected ? 1.5 : 1,
                          ),
                          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(backgroundColor: Color(colors[index].$2), radius: 7),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                colors[index].$1,
                                style: const TextStyle(fontSize: 11, color: Colors.black),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                // أزرار إضافة للسلة والكمية
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
                          elevation: 0,
                        ),
                        onPressed: () {},
                        icon: const Icon(Icons.shopping_bag_outlined, size: 18, color: Colors.white),
                        label: const Text('إضافة إلى السلة', style: TextStyle(fontSize: 13, color: Colors.white)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      height: 45,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.add, size: 16, color: Colors.black),
                            onPressed: () => setState(() => quantity++),
                          ),
                          Text('$quantity', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black)),
                          IconButton(
                            icon: const Icon(Icons.remove, size: 16, color: Colors.black),
                            onPressed: quantity > 1 ? () => setState(() => quantity--) : null,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // وصف المنتج
                const Text('وصف المنتج', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black)),
                const SizedBox(height: 8),
                Text(
                  'يعمل سيروم التجديد الفاخر على إعادة الحيوية للبشرة من خلال تركيبته الفريدة الغنية بالهيالورونيك والبروتينات، ويسهم في تقليل التجاعيد الدقيقة وتوحيد لون البشرة للحصول على مظهر مشرق.',
                  style: TextStyle(color: Colors.grey.shade700, height: 1.6, fontSize: 12),
                ),
                const SizedBox(height: 20),
                // المكونات الأساسية
                const Text('المكونات الأساسية', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: const [
                    _IngredientChip('حمض الهيالورونيك'),
                    _IngredientChip('فيتامين C'),
                    _IngredientChip('مستخلص الشاي الأخضر'),
                    _IngredientChip('زيت الأرجان العضوي'),
                  ],
                ),
                const SizedBox(height: 24),
                // آراء العملاء
                const Text('آراء العملاء', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black)),
                const SizedBox(height: 12),
                _buildReviewItem('سارة أحمد', 'منتج رائع جداً، لاحظت فرقاً كبيراً في نضارة بشرتي بعد أسبوع واحد من الاستخدام.'),
                _buildReviewItem('نورة القحطاني', 'القوام خفيف جداً وتمتصه البشرة بسرعة، ننصح كل فتاة بتجربته.'),
                _buildReviewItem('محمد العتيبي', 'ممتاز ولكن السعر مرتفع قليلاً. الجودة لا يعلى عليها.'),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text('المزيد من التعليقات', style: TextStyle(color: Colors.black, fontSize: 12, decoration: TextDecoration.underline)),
                  ),
                ),
                const SizedBox(height: 24),
                // منتجات قد تعجبك أيضاً
                const Text('منتجات قد تعجبك أيضاً', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black)),
                const SizedBox(height: 12),
                SizedBox(
                  height: 190,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildSuggestedProduct('كريم مرطب يومي', '١٨٠ ر.س', product.imagePath),
                      _buildSuggestedProduct('غسول وجه لطيف', '٩٥ ر.س', product.imagePath),
                      _buildSuggestedProduct('تونر منعش', '١٤٥ ر.س', product.imagePath),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimerBox(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(2),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSizeOption(int index, String title, String price, String? oldPrice) {
    final isSelected = selectedSize == index;
    return GestureDetector(
      onTap: () => setState(() => selectedSize = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.white,
          border: Border.all(color: isSelected ? Colors.black : Colors.grey.shade300),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: TextStyle(color: isSelected ? Colors.white : Colors.black, fontSize: 12)),
            Row(
              children: [
                if (oldPrice != null) ...[
                  Text(
                    oldPrice,
                    style: TextStyle(
                      color: isSelected ? Colors.white60 : Colors.grey.shade600,
                      fontSize: 11,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                  const SizedBox(width: 6),
                ],
                Text(price, style: TextStyle(color: isSelected ? Colors.white : Colors.black, fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewItem(String name, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black)),
              Row(
                children: List.generate(
                  5,
                  (index) => const Icon(Icons.star, color: Colors.black, size: 11),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(text, style: TextStyle(color: Colors.grey.shade600, fontSize: 11, height: 1.4)),
        ],
      ),
    );
  }

  Widget _buildSuggestedProduct(String title, String price, String imagePath) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(left: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 130,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFFBE3D4),
              borderRadius: BorderRadius.circular(4),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.asset(imagePath, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const SizedBox.shrink()),
            ),
          ),
          const SizedBox(height: 6),
          Text(title, style: const TextStyle(fontSize: 11, color: Colors.black), maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 2),
          Text(price, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black)),
        ],
      ),
    );
  }
}

class _IngredientChip extends StatelessWidget {
  const _IngredientChip(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(label, style: const TextStyle(fontSize: 11, color: Colors.black)),
    );
  }
}