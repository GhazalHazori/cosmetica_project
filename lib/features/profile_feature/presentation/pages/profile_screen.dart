import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../di/injection_container.dart';
import '../cubit/profile_cubit.dart';
import '../widgets/profile_menu_item.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const String routeName = '/profile';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProfileCubit>(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.notifications_none_outlined,
                color: Color(0xFF0F172A), size: 24),
            onPressed: () {},
          ),
          centerTitle: true,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Color(0xFF1E3A2B),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.spa,
                    color: Colors.white, size: 14),
              ),
              const SizedBox(width: 6),
              const Text(
                'COSMETICA',
                style: TextStyle(
                  color: Color(0xFF0F172A),
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
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
                            child: const CircleAvatar(
                              radius: 50,
                              backgroundColor: Color(0xFFF1F5F9),
                              child: Icon(Icons.person,
                                  size: 50, color: Color(0xFF64748B)),
                            ),
                          ),
                          Positioned(
                            bottom: 4,
                            left: 4,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: Colors.black,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.edit_outlined,
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
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
                      profile?.email ?? '...',
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
                      onTap: () {},
                    ),
                    const SizedBox(height: 8),
                    ProfileMenuItem(
                      title: 'معلومات الحساب',
                      icon: Icons.person_outline,
                      onTap: () {},
                    ),
                    const SizedBox(height: 8),
                    ProfileMenuItem(
                      title: 'الدعم والتواصل',
                      icon: Icons.help_outline,
                      onTap: () {},
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
                      onTap: () {},
                    ),
                    const SizedBox(height: 8),
                    ProfileMenuItem(
                      title: 'من نحن',
                      icon: Icons.info_outline,
                      onTap: () {},
                    ),
                    const SizedBox(height: 8),
                    ProfileMenuItem(
                      title: 'انضم إلينا كمورد',
                      icon: Icons.handshake_outlined,
                      onTap: () {},
                    ),
                    const SizedBox(height: 32),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        side: const BorderSide(
                            color: Color(0xFF0F172A), width: 1.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
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
    );
  }
}
