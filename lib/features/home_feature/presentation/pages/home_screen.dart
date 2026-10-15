import 'package:cosmetica_project/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

import '../../../product_details_feature/domain/entities/product_detail_entity.dart';
import '../../../product_details_feature/presentation/pages/product_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const _green = Color(0xFF2D5A43);
  static const _text = Color(0xFF171717);
  static const _cardBorder = Color(0xFFF1F5F9);
  static const _cardShadow = Color(0x14000000);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading:  Padding(
          padding:  EdgeInsets.symmetric(horizontal: AppSpacing.xs),
          child: Image.asset(
            'assets/images/cosmatica_logo.png',
            width: 28,
            height: 28,
            errorBuilder: (_, __, ___) => Container(color: _green),
          ),
        ),
        title: const Text(
          'COSMETICA',
          style: TextStyle(
            color: _text,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
          tooltip: 'البحث',
          icon: const Icon(Icons.search, color: _text),
          onPressed: () {},
        ),
         
        ],
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                   const Divider(height: 1, color: Color(0xFFF1F5F9)),
                     const SizedBox(height: 10),
              _buildHeroBanner(),
              const SizedBox(height: 24),
              _buildSectionHeader('اكتشفي المجموعات', showMore: true),
              const SizedBox(height: 12),
              _buildCategories(),
              const SizedBox(height: 24),
              _buildSectionHeader('وصلنا حديثاً'),
              const SizedBox(height: 12),
              _buildProducts(context, [
                _Product(
                  'سيروم الليل المجدد',
                  'إيسنس باريس',
                  '240 ر.س',
                  const Color(0xFF5A6B5C),
                ),
                _Product(
                  'كريم الترطيب المكثف',
                  'إينس أومير',
                  '315 ر.س',
                  const Color(0xFF6B7B6C),
                ),
              ]),
              const SizedBox(height: 24),
              _buildSectionHeader('الأكثر مبيعاً', showMore: true),
              const SizedBox(height: 12),
              _buildProducts(context, [
                _Product(
                  'مجموعة أحمر الشفاه',
                  'الأفضل تقييماً',
                  '450 ر.س',
                  const Color(0xFF88A08B),
                ),
                _Product(
                  'عطر روح الطبيعة',
                  'الأكثر طلباً',
                  '580 ر.س',
                  const Color(0xFFEBEBEB),
                ),
              ]),
              const SizedBox(height: 24),
              _buildSectionHeader('عروض خاصة'),
              const SizedBox(height: 12),
              _buildProducts(context, [
                _Product(
                  'مجموعة النضارة الفائقة',
                  'روتين العناية',
                  '180 ر.س',
                  const Color(0xFFFFD1D1),
                  'خصم 15%',
                ),
                _Product(
                  'كريم ليلي مجدد',
                  'إينس أومير',
                  '268 ر.س',
                  const Color(0xFF5A6B5C),
                  'خصم 15%',
                ),
              ]),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroBanner() {
    return Container(
      height: 380,
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Stack(
        children: [
          Image.asset(
            'assets/images/ads_home_image.png',
                    
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'اكتشفي الجمال الراقي',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'مجموعة حصرية من أرقى مستحضرات\nالتجميل العالمية بين يديك',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: _text,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'تسوقي الآن',
                        style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Almarai'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, {bool showMore = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(width: 3, height: 18, color: _text),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Color(0xff0F172A)),
            ),
          ],
        ),
        if (showMore)
          const Text(
            'عرض الكل',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xff64748B),
              decoration: TextDecoration.underline,
              decorationColor: Color(0xff64748B)
            ),
          ),
      ],
    );
  }

  Widget _buildCategories() {
    const categories = [
      ('العناية بالبشرة', Icons.spa_outlined),
      ('المكياج', Icons.brush_outlined),
      ('العطور', Icons.water_drop_outlined),
    ];

    return SizedBox(
      height: 250,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, index) {
          final category = categories[index];
          return SizedBox(
            width: 160,
            child: Column(
              children: [
                Container(
                  height: 213,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F2F2),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    // border: Border.all(color: Color(0xff0F172A),width: 1.5),
                  ),
                  child:ClipRRect(
  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
  child: Image.asset(
    "assets/images/category_image.jpg",
    fit: BoxFit.cover,
  ),
)
                ),
                const SizedBox(height: 6),
                Text(
                  category.$1,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff0F172A)
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProducts(BuildContext context, List<_Product> products) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          products
              .map((product) => Expanded(child: _buildProduct(context, product)))
              .toList(),
    );
  }

  Widget _buildProduct(BuildContext context, _Product product) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              GestureDetector(
                onTap: () => Navigator.pushNamed(
                  context,
                  ProductDetailScreen.routeName,
                  arguments: ProductDetailEntity(
                    title: product.title,
                    brand: product.brand,
                    price: product.price,
                    color: ColorValue(product.color.toARGB32()),
                    discount: product.discount,
                  ),
                ),
                child: Container(
                  height: 160,
                  decoration: BoxDecoration(
                    color: product.color,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    // Soft lift instead of a hard black outline.
                    border: Border.all(color: _cardBorder),
                    boxShadow: const [
                      BoxShadow(
                        color: _cardShadow,
                        blurRadius: 16,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    child: Image.asset(
                      "assets/images/update_image.jpg",
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                ),
              ),
              PositionedDirectional(
                top: AppSpacing.sm,
                start: AppSpacing.sm,
                child: DecoratedBox(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: _cardShadow,
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton.filledTonal(
                    tooltip: 'إضافة للمفضلة',
                    onPressed: () {},
                    icon: const Icon(Icons.favorite_border, size: 18),
                    // The theme has no onSecondaryContainer, so tonal buttons
                    // fall back to onSecondary (white) — set it explicitly.
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: _text,
                      minimumSize: const Size(36, 36),
                      fixedSize: const Size(36, 36),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ),
              if (product.discount != null)
                PositionedDirectional(
                  top: 8,
                  end: 8,
                  child: Container(
                  decoration: BoxDecoration(
                                        color: Colors.black,
                      borderRadius: BorderRadius.circular(2),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    child: Text(
                      product.discount!,
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            product.brand,
            style: const TextStyle(color: Color(0xff64748B), fontSize: 11,fontFamily: 'Almarai',fontWeight: FontWeight.bold),
          ),
          Text(
            product.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold,color: Color(0xff0F172A),fontFamily: 'Almarai'),
          ),
          const SizedBox(height: 2),
          Text(
            product.price,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600,color: Color(0xff0F172A),fontFamily: 'Almarai'),
          ),
        ],
      ),
    );
  }
}

class _Product {
  final String title;
  final String brand;
  final String price;
  final Color color;
  final String? discount;

  const _Product(
    this.title,
    this.brand,
    this.price,
    this.color, [
    this.discount,
  ]);
}
