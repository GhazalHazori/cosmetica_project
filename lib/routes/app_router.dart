import 'package:cosmetica_project/core/localization/app_localizations.dart';
import 'package:cosmetica_project/core/widgets/app_action_bottom_sheet.dart';
import 'package:cosmetica_project/core/widgets/app_loader.dart';
import 'package:cosmetica_project/di/injection_container.dart';
import 'package:cosmetica_project/features/about_feature/presentation/pages/about_us_screen.dart';
import 'package:cosmetica_project/features/business_signup_feature/presentation/cubit/business_signup_cubit.dart';
import 'package:cosmetica_project/features/business_signup_feature/presentation/pages/company_sign_up_page.dart';
import 'package:cosmetica_project/features/login_feature/presentation/pages/login_page.dart';
import 'package:cosmetica_project/features/home_feature/presentation/pages/main_layout_screen.dart';
import 'package:cosmetica_project/features/otp_verification_feature/presentation/cubit/otp_verification_cubit.dart';
import 'package:cosmetica_project/features/otp_verification_feature/presentation/pages/otp_verification_screen.dart';
import 'package:cosmetica_project/features/account_info_feature/presentation/pages/account_info_screen.dart';
import 'package:cosmetica_project/features/account_info_feature/presentation/cubit/account_info_cubit.dart';
import 'package:cosmetica_project/features/completed_order_details_feature/presentation/pages/completed_order_details_screen.dart';
import 'package:cosmetica_project/features/my_orders_feature/presentation/pages/my_orders_screen.dart';
import 'package:cosmetica_project/features/notifications_feature/presentation/pages/notifications_screen.dart';
import 'package:cosmetica_project/features/order_details_feature/presentation/pages/order_details_screen.dart';
import 'package:cosmetica_project/features/payment_methods_feature/presentation/pages/payment_methods_screen.dart';
import 'package:cosmetica_project/features/product_details_feature/domain/entities/product_detail_entity.dart';
import 'package:cosmetica_project/features/product_details_feature/presentation/pages/product_detail_screen.dart';
import 'package:cosmetica_project/features/profile_feature/presentation/pages/profile_screen.dart';
import 'package:cosmetica_project/features/privacy_policy_feature/presentation/pages/privacy_policy_screen.dart';
import 'package:cosmetica_project/features/reset_password_feature/presentation/cubit/reset_password_cubit.dart';
import 'package:cosmetica_project/features/reset_password_feature/presentation/pages/reset_password_screen.dart';
import 'package:cosmetica_project/features/sample_feature/presentation/pages/sample_page.dart';
import 'package:cosmetica_project/features/search_feature/presentation/pages/search_categories_screen.dart';
import 'package:cosmetica_project/features/supplier_registration_feature/presentation/pages/supplier_registration_screen.dart';
import 'package:cosmetica_project/features/submit_complaint_feature/presentation/pages/submit_complaint_screen.dart';
import 'package:cosmetica_project/features/signup_feature/presentation/cubit/signup_cubit.dart';
import 'package:cosmetica_project/features/signup_feature/presentation/pages/sign_up_page.dart';
import 'package:cosmetica_project/features/splash_feature/presentation/pages/splash_page.dart';
import 'package:cosmetica_project/features/support_contact_feature/presentation/pages/support_and_contact_screen.dart';
import 'package:cosmetica_project/features/support_contact_feature/presentation/pages/live_chat_screen.dart';
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
        return _fadeRoute(const LoginPage(), settings);
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
                        arguments: OtpVerificationArgs(
                          phoneNumber: state.phone ?? '',
                          codeSentAt: DateTime.now(),
                        ),
                      );
                    } else if (state.status == SignupStatus.phoneTaken) {
                      _offerResumeVerification(
                        context,
                        phone: state.phone ?? '',
                        isBusiness: false,
                      );
                    } else if (state.status == SignupStatus.failure) {
                      _showError(context, state.errorMessage);
                    }
                  },
                  child: AppLoadingOverlay<SignupCubit, SignupState>(
                    isLoading: (state) => state.status == SignupStatus.loading,
                    child: const SignUpPage(),
                  ),
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
                        arguments: OtpVerificationArgs(
                          phoneNumber: state.phone ?? '',
                          isBusiness: true,
                          codeSentAt: DateTime.now(),
                        ),
                      );
                    } else if (state.status ==
                        BusinessSignupStatus.phoneTaken) {
                      _offerResumeVerification(
                        context,
                        phone: state.phone ?? '',
                        isBusiness: true,
                      );
                    } else if (state.status == BusinessSignupStatus.failure) {
                      _showError(context, state.errorMessage);
                    }
                  },
                  child: AppLoadingOverlay<BusinessSignupCubit,
                      BusinessSignupState>(
                    isLoading: (state) =>
                        state.status == BusinessSignupStatus.loading,
                    child: const CompanySignUpPage(),
                  ),
                ),
              ),
          settings: settings,
        );
      case OtpVerificationScreen.routeName:
        return MaterialPageRoute(
          builder:
              (_) => BlocProvider<OtpVerificationCubit>(
                create: (_) => sl<OtpVerificationCubit>(),
                child: AppLoadingOverlay<OtpVerificationCubit,
                    OtpVerificationState>(
                  isLoading: (state) =>
                      state.status == OtpVerificationStatus.loading,
                  child: OtpVerificationScreen.fromRouteSettings(settings),
                ),
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
      case MyOrdersScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => const MyOrdersScreen(),
          settings: settings,
        );
      case OrderDetailsScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => const OrderDetailsScreen(),
          settings: settings,
        );
      case CompletedOrderDetailsScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => const CompletedOrderDetailsScreen(),
          settings: settings,
        );
      case AccountInfoScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => BlocProvider<AccountInfoCubit>(
            create: (_) => sl<AccountInfoCubit>(),
            child: AppLoadingOverlay<AccountInfoCubit, AccountInfoState>(
              isLoading: (state) => state.status == AccountInfoStatus.loading,
              child: const AccountInfoScreen(),
            ),
          ),
          settings: settings,
        );
      case SupportAndContactScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => const SupportAndContactScreen(),
          settings: settings,
        );
      case LiveChatScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => const LiveChatScreen(),
          settings: settings,
        );
      case PrivacyPolicyScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => const PrivacyPolicyScreen(),
          settings: settings,
        );
      case AboutUsScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => const AboutUsScreen(),
          settings: settings,
        );
      case SupplierRegistrationScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => const SupplierRegistrationScreen(),
          settings: settings,
        );
      case SubmitComplaintScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => const SubmitComplaintScreen(),
          settings: settings,
        );
      case ProductDetailScreen.routeName:
        final product = settings.arguments as ProductDetailEntity;
        return MaterialPageRoute(
          builder: (_) => ProductDetailScreen(product: product),
          settings: settings,
        );
      case ResetPasswordScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => BlocProvider<ResetPasswordCubit>(
            create: (_) => sl<ResetPasswordCubit>(),
            child: AppLoadingOverlay<ResetPasswordCubit, ResetPasswordState>(
              isLoading: (state) =>
                  state.status == ResetPasswordStatus.loading,
              child: const ResetPasswordScreen(),
            ),
          ),
          settings: settings,
        );
      case NotificationsScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => const NotificationsScreen(),
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

  /// The number already has an account, maybe one never verified: offer to
  /// verify it (a code is sent only if it is awaiting verification) or to
  /// sign in.
  static Future<void> _offerResumeVerification(
    BuildContext context, {
    required String phone,
    required bool isBusiness,
  }) async {
    final l10n = AppLocalizations.of(context);
    final navigator = Navigator.of(context);
    final choice = await showAppActionBottomSheet<_PhoneTakenChoice>(
      context,
      icon: Icons.phone_iphone_outlined,
      title: l10n.tr('phone_taken.title'),
      message: l10n.tr('phone_taken.message'),
      actions: [
        AppSheetAction(
          label: l10n.tr('phone_taken.verify'),
          value: _PhoneTakenChoice.verify,
          isPrimary: true,
        ),
        AppSheetAction(
          label: l10n.tr('phone_taken.login'),
          value: _PhoneTakenChoice.login,
        ),
      ],
    );
    switch (choice) {
      case _PhoneTakenChoice.verify:
        navigator.pushReplacementNamed(
          OtpVerificationScreen.routeName,
          arguments: OtpVerificationArgs(
            phoneNumber: phone,
            isBusiness: isBusiness,
            sendCode: true,
          ),
        );
      case _PhoneTakenChoice.login:
        navigator.pushNamedAndRemoveUntil(
          LoginPage.routeName,
          (route) => false,
        );
      case null:
        break;
    }
  }

  /// Shows the server's message, or a generic one when there is none
  /// (e.g. no connection).
  static void _showError(BuildContext context, String? message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message == null || message.isEmpty
              ? AppLocalizations.of(context).tr('auth.error_generic')
              : message,
        ),
      ),
    );
  }

  static Route<dynamic> _fadeRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder<dynamic>(
      settings: settings,
      transitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          ),
          child: child,
        );
      },
    );
  }
}

enum _PhoneTakenChoice { verify, login }
