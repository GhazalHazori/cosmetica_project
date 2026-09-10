import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  final String id;
  final String title;
  final List<CategoryEntity>? children;

  const CategoryEntity({
    required this.id,
    required this.title,
    this.children,
  });

  @override
  List<Object?> get props => [id, title, children];
}
