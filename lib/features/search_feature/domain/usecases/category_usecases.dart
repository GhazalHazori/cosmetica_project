 
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/category_entity.dart';
import '../repositories/category_repository.dart';

class GetCategoriesUseCase {
  final CategoryRepository _repository;

  GetCategoriesUseCase(this._repository);

  Future<Either<Failure, List<CategoryEntity>>> call() {
    return _repository.getCategories();
  }
}

class SearchCategoriesUseCase {
  final CategoryRepository _repository;

  SearchCategoriesUseCase(this._repository);

  Future<Either<Failure, List<CategoryEntity>>> call(String query) {
    return _repository.searchCategories(query);
  }
}
