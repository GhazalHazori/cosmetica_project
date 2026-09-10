import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/category_entity.dart';
import '../../domain/usecases/category_usecases.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final GetCategoriesUseCase _getCategoriesUseCase;
  final SearchCategoriesUseCase _searchCategoriesUseCase;
  Timer? _debounce;

  SearchCubit(
    this._getCategoriesUseCase,
    this._searchCategoriesUseCase,
  ) : super(const SearchState.initial()) {
    loadCategories();
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }

  Future<void> loadCategories() async {
    if (isClosed) return;
    emit(state.copyWith(status: SearchStatus.loading));

    final result = await _getCategoriesUseCase();

    if (isClosed) return;
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: SearchStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (categories) => emit(
        state.copyWith(
          status: SearchStatus.success,
          categories: categories,
          filteredCategories: categories,
        ),
      ),
    );
  }

  void search(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _performSearch(query);
    });
  }

  void clearSearch() {
    _debounce?.cancel();
    if (isClosed) return;
    emit(state.copyWith(filteredCategories: state.categories));
  }

  Future<void> _performSearch(String query) async {
    if (isClosed) return;
    if (query.isEmpty) {
      emit(state.copyWith(filteredCategories: state.categories));
      return;
    }

    emit(state.copyWith(status: SearchStatus.loading));

    final result = await _searchCategoriesUseCase(query);

    if (isClosed) return;
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: SearchStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (filtered) => emit(
        state.copyWith(
          status: SearchStatus.success,
          filteredCategories: filtered,
        ),
      ),
    );
  }
}
