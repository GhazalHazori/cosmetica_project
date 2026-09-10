import 'package:cosmetica_project/di/injection_container.dart';
import 'package:cosmetica_project/features/business_signup_feature/presentation/cubit/business_signup_cubit.dart';
import 'package:cosmetica_project/features/business_signup_feature/presentation/pages/company_sign_up_page.dart';
import 'package:cosmetica_project/features/login_feature/presentation/pages/login_page.dart';
import 'package:cosmetica_project/features/home_feature/presentation/pages/main_layout_screen.dart';
import 'package:cosmetica_project/features/otp_verification_feature/presentation/cubit/otp_verification_cubit.dart';
import 'package:cosmetica_project/features/otp_verification_feature/presentation/pages/otp_verification_screen.dart';
import 'package:cosmetica_project/features/payment_methods_feature/presentation/pages/payment_methods_screen.dart';
import 'package:cosmetica_project/features/sample_feature/presentation/pages/sample_page.dart';
import 'package:cosmetica_project/features/search_feature/presentation/pages/search_categories_screen.dart';
import 'package:cosmetica_project/features/profile_feature/presentation/pages/profile_screen.dart';
import 'package:cosmetica_project/features/signup_feature/presentation/cubit/signup_cubit.dart';
import 'package:cosmetica_project/features/signup_feature/presentation/pages/sign_up_page.dart';
import 'package:cosmetica_project/features/splash_feature/presentation/pages/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      case SignUpPage.routeName:
        return MaterialPageRoute(
          builder:
              (_) => BlocProvider<SignupCubit>(
                create: (_) => sl<SignupCubit>(),
                child: BlocListener<SignupCubit, SignupState>(
                  listenWhen:
                      (previous, current) => previous.status != current.status,
                  listener: (context, state) {
                    if (state.status == SignupStatus.success) {
                      Navigator.pushReplacementNamed(
                        context,
                        OtpVerificationScreen.routeName,
                        arguments: '',
                      );
                    } else if (state.status == SignupStatus.failure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.errorMessage ?? 'Signup failed'),
                        ),
                      );
                    }
                  },
                  child: const SignUpPage(),
                ),
              ),
          settings: settings,
        );
      case CompanySignUpPage.routeName:
        return MaterialPageRoute(
          builder:
              (_) => BlocProvider<BusinessSignupCubit>(
                create: (_) => sl<BusinessSignupCubit>(),
                child: BlocListener<BusinessSignupCubit, BusinessSignupState>(
                  listenWhen:
                      (previous, current) => previous.status != current.status,
                  listener: (context, state) {
                    if (state.status == BusinessSignupStatus.success) {
                      Navigator.pushReplacementNamed(
                        context,
                        OtpVerificationScreen.routeName,
                        arguments: '',
                      );
                    } else if (state.status == BusinessSignupStatus.failure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.errorMessage ?? 'Signup failed'),
                        ),
                      );
                    }
                  },
                  child: const CompanySignUpPage(),
                ),
              ),
          settings: settings,
        );
      case OtpVerificationScreen.routeName:
        return MaterialPageRoute(
          builder:
              (_) => BlocProvider<OtpVerificationCubit>(
                create: (_) => sl<OtpVerificationCubit>(),
                child: OtpVerificationScreen.fromRouteSettings(settings),
              ),
          settings: settings,
        );
      case MainLayoutScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => const MainLayoutScreen(),
          settings: settings,
        );
      case PaymentMethodsScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => const PaymentMethodsScreen(),
          settings: settings,
        );
      case SearchCategoriesScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => const SearchCategoriesScreen(),
          settings: settings,
        );
      case ProfileScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => const ProfileScreen(),
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
