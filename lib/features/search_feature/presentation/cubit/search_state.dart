part of 'search_cubit.dart';

enum SearchStatus { initial, loading, success, failure }

class SearchState extends Equatable {
  final SearchStatus status;
  final List<CategoryEntity> categories;
  final List<CategoryEntity> filteredCategories;
  final String? errorMessage;

  const SearchState({
    required this.status,
    required this.categories,
    required this.filteredCategories,
    this.errorMessage,
  });

  const SearchState.initial()
      : status = SearchStatus.initial,
        categories = const [],
        filteredCategories = const [],
        errorMessage = null;

  SearchState copyWith({
    SearchStatus? status,
    List<CategoryEntity>? categories,
    List<CategoryEntity>? filteredCategories,
    String? errorMessage,
  }) {
    return SearchState(
      status: status ?? this.status,
      categories: categories ?? this.categories,
      filteredCategories: filteredCategories ?? this.filteredCategories,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, categories, filteredCategories, errorMessage];
}
