class ProductDetailEntity {
  const ProductDetailEntity({
    required this.title,
    required this.brand,
    required this.price,
    required this.color,
    this.discount,
    this.imagePath = 'assets/images/update_image.jpg',
  });

  final String title;
  final String brand;
  final String price;
  final ColorValue color;
  final String? discount;
  final String imagePath;
}

class ColorValue {
  const ColorValue(this.value);

  final int value;
}
