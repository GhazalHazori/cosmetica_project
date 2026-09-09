import 'package:flutter/material.dart';

import '../features/login_feature/presentation/pages/login_page.dart';
import '../features/sample_feature/presentation/pages/sample_page.dart';
import '../features/splash_feature/presentation/pages/splash_page.dart';

class AppRouter {
  static const String initialRoute = SplashPage.routeName;

  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case SplashPage.routeName:
        return MaterialPageRoute(
          builder: (_) => const SplashPage(),
          settings: settings,
        );
      case LoginPage.routeName:
        return MaterialPageRoute(
          builder: (_) => const LoginPage(),
          settings: settings,
        );
      case SamplePage.routeName:
        return MaterialPageRoute(
          builder: (_) => const SamplePage(),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const SplashPage(),
          settings: settings,
        );
    }
  }
}


