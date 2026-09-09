import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/bottom_nav_cubit.dart';
import '../../../../di/injection_container.dart';
import '../../../cart_feature/presentation/pages/cart_screen.dart';
import '../../../favorites_feature/presentation/pages/favorites_screen.dart';
import 'home_screen.dart';

class MainLayoutScreen extends StatelessWidget {
  const MainLayoutScreen({super.key});

  static const String routeName = '/home';

  static const _screens = <Widget>[
    HomeScreen(),
    FavoritesScreen(),
    CartScreen(),
    _PlaceholderScreen(title: 'البحث', icon: Icons.search),
    _PlaceholderScreen(title: 'حسابي', icon: Icons.person_outline),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<BottomNavCubit>(),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: BlocBuilder<BottomNavCubit, int>(
          builder: (context, currentIndex) {
            return Scaffold(
              backgroundColor: Colors.white,
              body: IndexedStack(index: currentIndex, children: _screens),
              bottomNavigationBar: Container(
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
                ),
                child: BottomNavigationBar(
                  currentIndex: currentIndex,
                  onTap: context.read<BottomNavCubit>().changeIndex,
                  type: BottomNavigationBarType.fixed,
                  backgroundColor: Colors.white,
                  selectedItemColor: Colors.black,
                  unselectedItemColor: Colors.black45,
                  selectedFontSize: 11,
                  unselectedFontSize: 11,
                  selectedLabelStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  elevation: 0,
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home_outlined),
                      activeIcon: Icon(Icons.home),
                      label: 'الرئيسية',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.favorite_border),
                      activeIcon: Icon(Icons.favorite),
                      label: 'المفضلة',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.shopping_bag_outlined),
                      activeIcon: Icon(Icons.shopping_bag),
                      label: 'السلة',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.search),
                      label: 'البحث',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person_outline),
                      activeIcon: Icon(Icons.person),
                      label: 'حسابي',
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _PlaceholderScreen extends StatelessWidget {
  final String title;
  final IconData icon;

  const _PlaceholderScreen({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Icon(icon, size: 56, color: Colors.black54)),
    );
  }
}
