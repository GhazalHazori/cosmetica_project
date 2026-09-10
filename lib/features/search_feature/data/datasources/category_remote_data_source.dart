import '../../domain/entities/category_entity.dart';

abstract class CategoryRemoteDataSource {
  Future<List<CategoryEntity>> getCategories();
  Future<List<CategoryEntity>> searchCategories(String query);
}

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  @override
  Future<List<CategoryEntity>> getCategories() async {
    return [
      CategoryEntity(
        id: 'perfumes',
        title: 'عطور',
        children: const [
          CategoryEntity(id: 'perfumes_women', title: 'عطور نسائية'),
          CategoryEntity(id: 'perfumes_men', title: 'عطور رجالية'),
          CategoryEntity(id: 'perfumes_kids', title: 'عطور الأطفال'),
        ],
      ),
      CategoryEntity(
        id: 'makeup',
        title: 'مكياجات',
        children: const [
          CategoryEntity(id: 'lipstick', title: 'أحمر شفاه'),
          CategoryEntity(
            id: 'mascara',
            title: 'ماسكارا',
            children: [
              CategoryEntity(id: 'mascara_waterproof', title: 'ماسكارا ضد الماء'),
              CategoryEntity(id: 'mascara_normal', title: 'عادية'),
              CategoryEntity(id: 'mascara_brown', title: 'بني'),
            ],
          ),
          CategoryEntity(id: 'foundation', title: 'فونديشين'),
        ],
      ),
      CategoryEntity(
        id: 'mother_child',
        title: 'الأم والطفل',
        children: const [
          CategoryEntity(id: 'care_supplies', title: 'مستلزمات العناية'),
          CategoryEntity(id: 'clothing', title: 'ملابس'),
        ],
      ),
      CategoryEntity(
        id: 'skincare',
        title: 'العناية بالبشرة',
        children: const [
          CategoryEntity(id: 'moisturizers', title: 'مرطبات'),
          CategoryEntity(id: 'cleansers', title: 'غسول'),
          CategoryEntity(id: 'serums', title: 'سيروم'),
        ],
      ),
      CategoryEntity(
        id: 'haircare',
        title: 'العناية بالشعر',
        children: const [
          CategoryEntity(id: 'shampoo', title: 'شامبو'),
          CategoryEntity(id: 'oils', title: 'زيوت'),
          CategoryEntity(id: 'hair_devices', title: 'أجهزة شعر'),
        ],
      ),
      CategoryEntity(
        id: 'bath_supplies',
        title: 'مستلزمات الاستحمام',
        children: const [
          CategoryEntity(id: 'soap', title: 'صابون'),
          CategoryEntity(id: 'bath_salts', title: 'أملاح الاستحمام'),
        ],
      ),
      CategoryEntity(
        id: 'nail_care',
        title: 'العناية بالأظافر',
        children: const [
          CategoryEntity(id: 'nail_polish', title: 'طلاء أظافر'),
          CategoryEntity(id: 'care_tools', title: 'أدوات العناية'),
        ],
      ),
      CategoryEntity(
        id: 'contact_lenses',
        title: 'عدسات لاصقة',
        children: const [
          CategoryEntity(id: 'colored_lenses', title: 'عدسات ملونة'),
          CategoryEntity(id: 'medical_lenses', title: 'عدسات طبية'),
        ],
      ),
      CategoryEntity(
        id: 'beauty_devices',
        title: 'أجهزة التجميل',
        children: const [
          CategoryEntity(id: 'skin_care_devices', title: 'أجهزة تنظيف البشرة'),
          CategoryEntity(id: 'hair_removal_devices', title: 'أجهزة إزالة الشعر'),
        ],
      ),
    ];
  }

  @override
  Future<List<CategoryEntity>> searchCategories(String query) async {
    final all = await getCategories();
    return _searchRecursive(all, query);
  }

  List<CategoryEntity> _searchRecursive(
    List<CategoryEntity> categories,
    String query,
  ) {
    final results = <CategoryEntity>[];
    for (final category in categories) {
      if (category.title.contains(query)) {
        results.add(category);
      }
      if (category.children != null) {
        final childResults = _searchRecursive(category.children!, query);
        if (childResults.isNotEmpty) {
          results.add(
            CategoryEntity(
              id: category.id,
              title: category.title,
              children: childResults,
            ),
          );
        }
      }
    }
    return results;
  }
}
