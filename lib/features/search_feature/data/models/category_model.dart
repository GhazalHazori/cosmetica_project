import '../../domain/entities/category_entity.dart';

class CategoryModel extends CategoryEntity {
  const CategoryModel({
    required super.id,
    required super.title,
    super.children,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    final childrenJson = json['children'] as List<dynamic>?;
    return CategoryModel(
      id: json['id'] as String,
      title: json['title'] as String,
      children: childrenJson
          ?.map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      if (children != null)
        'children': children!
            .map((e) => (e as CategoryModel).toJson())
            .toList(),
    };
  }
}
