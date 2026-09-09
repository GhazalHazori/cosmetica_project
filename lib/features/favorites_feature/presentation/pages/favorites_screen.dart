import 'package:flutter/material.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final List<_FavoriteProduct> _favoriteProducts = [
    const _FavoriteProduct(
      brand: 'إستي لودر',
      title: 'سيروم ليلي متطور لإصلاح البشرة',
      price: '450 ر.س',
      oldPrice: '650 ر.س',
      rating: '4.8',
      timerText: '02:15:45',
      badgeText: 'شحن مجاني',
      imageColor: Color(0xFFD8A878),
    ),
    const _FavoriteProduct(
      brand: 'ديور',
      title: 'أحمر شفاه روج ديور - كلاسيك',
      price: '210 ر.س',
      rating: '5.0',
      imageColor: Color(0xFFE5A19C),
    ),
    const _FavoriteProduct(
      brand: 'شانيل',
      title: 'عطر كوكو مدموزيل - 50 مل',
      price: '680 ر.س',
      rating: '4.2',
      imageColor: Color(0xFFC7A26B),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          tooltip: 'السلة',
          icon: const Icon(
            Icons.shopping_bag_outlined,
            color: Colors.black,
            size: 24,
          ),
          onPressed: () {},
        ),
        title: const Text(
          'C O S M E T I C A',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'البحث',
            icon: const Icon(Icons.search, color: Colors.black, size: 26),
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
              const Text(
                'المفضلة',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 2),
              const Text(
                'منتجاتك المختارة بعناية',
                style: TextStyle(fontSize: 14, color: Color(0xFF758A99)),
              ),
              const SizedBox(height: 20),
              if (_favoriteProducts.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 80),
                    child: Text('لا توجد منتجات في المفضلة'),
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _favoriteProducts.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (_, index) => _buildFavoriteCard(index),
                ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFavoriteCard(int index) {
    final product = _favoriteProducts[index];

    return Container(
      height: 170,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 1.2),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        product.brand,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF8C9BA5),
                        ),
                      ),
                      const Icon(Icons.favorite, size: 20, color: Colors.black),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        product.price,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (product.oldPrice != null) ...[
                        const SizedBox(width: 8),
                        Text(
                          product.oldPrice!,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap:
                            () => setState(
                              () => _favoriteProducts.removeAt(index),
                            ),
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                          ),
                          child: const Icon(Icons.delete_outline, size: 18),
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            '(${product.rating})',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF6B7C85),
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Row(
                            children: [
                              Icon(
                                Icons.star,
                                size: 14,
                                color: Color(0xFFFFC107),
                              ),
                              Icon(
                                Icons.star,
                                size: 14,
                                color: Color(0xFFFFC107),
                              ),
                              Icon(
                                Icons.star,
                                size: 14,
                                color: Color(0xFFFFC107),
                              ),
                              Icon(
                                Icons.star,
                                size: 14,
                                color: Color(0xFFFFC107),
                              ),
                              Icon(
                                Icons.star,
                                size: 14,
                                color: Color(0xFFFFC107),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: 135,
            height: double.infinity,
            color: product.imageColor,
            child:
                product.timerText == null
                    ? const Icon(
                      Icons.shopping_bag_outlined,
                      size: 56,
                      color: Colors.white70,
                    )
                    : Stack(
                      children: [
                        const Center(
                          child: Icon(
                            Icons.shopping_bag_outlined,
                            size: 56,
                            color: Colors.white70,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 6,
                            ),
                            color: Colors.black.withValues(alpha: 0.85),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      product.timerText!,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 2),
                                    const Text(
                                      'عرض خلال',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 9,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  product.badgeText!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
          ),
        ],
      ),
    );
  }
}

class _FavoriteProduct {
  final String brand;
  final String title;
  final String price;
  final String? oldPrice;
  final String rating;
  final String? timerText;
  final String? badgeText;
  final Color imageColor;

  const _FavoriteProduct({
    required this.brand,
    required this.title,
    required this.price,
    this.oldPrice,
    required this.rating,
    this.timerText,
    this.badgeText,
    required this.imageColor,
  });
}
