import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../di/injection_container.dart';
import '../cubit/search_cubit.dart';

class SearchCategoriesScreen extends StatefulWidget {
  const SearchCategoriesScreen({super.key});

  static const String routeName = '/search-categories';

  @override
  State<SearchCategoriesScreen> createState() => _SearchCategoriesScreenState();
}

class _SearchCategoriesScreenState extends State<SearchCategoriesScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SearchCubit>(),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text(
              'البحث',
              style: TextStyle(
                color: Color(0xFF0F172A),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 0,
          ),
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.maybePop(context);
                        },
                        icon: const Icon(Icons.arrow_back,
                            color: Color(0xFF0F172A)),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TextField(
                            controller: _searchController,
                            decoration: const InputDecoration(
                              hintText: 'ابحث عن منتج، علامة تجارية...',
                              hintStyle: TextStyle(
                                color: Color(0xFF94A3B8),
                                fontSize: 13,
                                fontFamily: 'Tajawal',
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                            onChanged: (value) {
                              context.read<SearchCubit>().search(value);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1, color: Color(0xFFF1F5F9)),
                Expanded(
                  child: BlocBuilder<SearchCubit, SearchState>(
                    buildWhen: (previous, current) =>
                        previous.filteredCategories !=
                        current.filteredCategories,
                    builder: (context, state) {
                      if (state.status == SearchStatus.loading &&
                          state.filteredCategories.isEmpty) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (state.status == SearchStatus.failure) {
                        return Center(
                          child: Text(
                            state.errorMessage ?? 'حدث خطأ',
                            style:
                                const TextStyle(color: Color(0xFF94A3B8)),
                          ),
                        );
                      }

                      final categories = state.filteredCategories;

                      if (categories.isEmpty) {
                        return const Center(
                          child: Text(
                            'لا توجد نتائج',
                            style: TextStyle(color: Color(0xFF94A3B8)),
                          ),
                        );
                      }

                      return ListView.separated(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        itemCount: categories.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 4),
                        itemBuilder: (context, index) {
                          final category = categories[index];
                          return _buildExpandableCategory(
                            context: context,
                            title: category.title,
                            children: category.children ?? [],
                            isInitiallyExpanded: index == 1,
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExpandableCategory({
    required BuildContext context,
    required String title,
    required List<dynamic> children,
    bool isInitiallyExpanded = false,
  }) {
    final hasChildren = children.isNotEmpty;

    if (!hasChildren) {
      return _buildCategoryItem(title);
    }

    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
      ),
      child: Container(
        color: isInitiallyExpanded
            ? const Color(0xFFF8FAFC)
            : Colors.transparent,
        child: ExpansionTile(
          initiallyExpanded: isInitiallyExpanded,
          iconColor: const Color(0xFF0F172A),
          collapsedIconColor: const Color(0xFF94A3B8),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF0F172A),
              fontWeight: FontWeight.w500,
            ),
          ),
          childrenPadding: const EdgeInsets.only(bottom: 8),
          children: children.map((item) {
            if (item is! String && item.children != null) {
              return _buildExpandableCategory(
                context: context,
                title: item.title,
                children: item.children!,
              );
            }
            if (item is! String) {
              return _buildCategoryItem(item.title);
            }
            return _buildCategoryItem(item);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildCategoryItem(String title) {
    return InkWell(
      onTap: () {},
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF475569),
          ),
        ),
      ),
    );
  }
}
