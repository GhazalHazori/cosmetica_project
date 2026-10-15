import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/bottom_nav_cubit.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/widgets/app_loader.dart';
import '../../../../di/injection_container.dart';
import '../../../login_feature/presentation/pages/login_page.dart';
import '../../../logout_feature/presentation/cubit/logout_cubit.dart';
import '../../../logout_feature/presentation/widgets/logout_confirm_bottom_sheet.dart';
import '../../../about_feature/presentation/pages/about_us_screen.dart';
import '../../../account_info_feature/presentation/pages/account_info_screen.dart';
import '../../../my_orders_feature/presentation/pages/my_orders_screen.dart';
import '../../../notifications_feature/presentation/pages/notifications_screen.dart';
import '../../../privacy_policy_feature/presentation/pages/privacy_policy_screen.dart';
import '../../../supplier_registration_feature/presentation/pages/supplier_registration_screen.dart';
import '../../../support_contact_feature/presentation/pages/support_and_contact_screen.dart';
import '../cubit/profile_cubit.dart';
import '../widgets/profile_menu_item.dart';
import '../../../../core/theme/app_spacing.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const String routeName = '/profile';
 static const _green = Color(0xFF2D5A43);
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<ProfileCubit>()),
        BlocProvider(create: (_) => sl<LogoutCubit>()),
      ],
      child: BlocListener<LogoutCubit, LogoutState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == LogoutStatus.success) {
            // Back to login with an empty navigation stack.
            Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
              LoginPage.routeName,
              (route) => false,
            );
          } else if (state.status == LogoutStatus.failure) {
            final message = state.errorMessage;
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
        },
        child: AppLoadingOverlay<LogoutCubit, LogoutState>(
          isLoading: (state) => state.status == LogoutStatus.loading,
          child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          actions:[ IconButton(
            icon: const Icon(Icons.notifications_none_outlined,
                color: Color(0xFF0F172A), size: 24),
            onPressed: () {
              Navigator.pushNamed(context, NotificationsScreen.routeName);
            },
          ),],
          leading: SizedBox.shrink(),
          centerTitle: true,
          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                            'assets/images/cosmatica_logo.png',
                            width: 70,
                            height: 70,
                            errorBuilder: (_, __, ___) => Container(color: _green),
                          ),
              const SizedBox(width: 6),
              // const Text(
              //   'COSMETICA',
              //   style: TextStyle(
              //     color: Color(0xFF0F172A),
              //     fontSize: 16,
              //     fontWeight: FontWeight.w900,
              //     letterSpacing: 2,
              //   ),
              // ),
                   
            ],
          ),
          bottom: PreferredSize(preferredSize:Size(1, 1) , child:   const Divider(height: 1, color: Color(0xFFF1F5F9),),),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: BlocBuilder<ProfileCubit, ProfileState>(
              builder: (context, state) {
                final profile = state.profile;
                return Column(
                  children: [
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: const Color(0xFFE2E8F0), width: 1.5),
                            ),
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: const Color(0xFFF1F5F9),
                              foregroundImage: profile?.photoUrl == null
                                  ? null
                                  : NetworkImage(profile!.photoUrl!),
                              child: const Icon(Icons.person,
                                  size: 50, color: Color(0xFF64748B)),
                            ),
                          ),
                          // Positioned(
                          //   bottom: 4,
                          //   left: 4,
                          //   child: Container(
                          //     padding: const EdgeInsets.all(6),
                          //     decoration: const BoxDecoration(
                          //       color: Colors.black,
                          //       shape: BoxShape.circle,
                          //     ),
                          //     child: const Icon(
                          //       Icons.edit_outlined,
                          //       size: 14,
                          //       color: Colors.white,
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      profile?.name ?? '...',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      profile?.contact ?? '...',
                      textDirection: TextDirection.ltr,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'النشاط',
                        style: TextStyle(
                          color: Color(0xFF94A3B8),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ProfileMenuItem(
                      title: 'طلباتي',
                      icon: Icons.inventory_2_outlined,
                      onTap: () {
                        final currentIndex = context.read<BottomNavCubit>().state;
                        Navigator.pushNamed(
                          context,
                          MyOrdersScreen.routeName,
                          arguments: currentIndex,
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    ProfileMenuItem(
                      title: 'معلومات الحساب',
                      icon: Icons.person_outline,
                      onTap: () async {
                        final profileCubit = context.read<ProfileCubit>();
                        await Navigator.pushNamed(
                          context,
                          AccountInfoScreen.routeName,
                        );
                        // The name or photo may have changed there.
                        profileCubit.loadProfile();
                      },
                    ),
                    const SizedBox(height: 8),
                    ProfileMenuItem(
                      title: 'الدعم والتواصل',
                      icon: Icons.help_outline,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          SupportAndContactScreen.routeName,
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'كوزماتيكا',
                        style: TextStyle(
                          color: Color(0xFF94A3B8),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ProfileMenuItem(
                      title: 'سياسة الخصوصية والاستخدام',
                      icon: Icons.gavel_outlined,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          PrivacyPolicyScreen.routeName,
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    ProfileMenuItem(
                      title: 'من نحن',
                      icon: Icons.info_outline,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AboutUsScreen.routeName,
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    ProfileMenuItem(
                      title: 'انضم إلينا كمورد',
                      icon: Icons.handshake_outlined,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          SupplierRegistrationScreen.routeName,
                        );
                      },
                    ),
                    const SizedBox(height: 32),
                    OutlinedButton(
                      onPressed: () async {
                        final logoutCubit = context.read<LogoutCubit>();
                        if (await showLogoutConfirmBottomSheet(context)) {
                          logoutCubit.logout();
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        side: const BorderSide(
                            color: Color(0xFF0F172A), width: 1.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.logout,
                              color: Color(0xFF0F172A), size: 18),
                          SizedBox(width: 8),
                          Text(
                            'تسجيل الخروج',
                            style: TextStyle(
                              color: Color(0xFF0F172A),
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                );
              },
            ),
          ),
        ),
      ),
        ),
      ),
    );
  }
}
