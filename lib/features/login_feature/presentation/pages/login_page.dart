import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../di/injection_container.dart';
import '../cubit/login_cubit.dart';

class AppColors {
  static const Color primaryText = Color(0xFF1E2832);
  static const Color secondaryText = Color(0xFF767F8A);
  static const Color accentText = Color(0xFF13171B);
  static const Color inputBorder = Color(0xFFD0D5DD);
  static const Color buttonBackground = Color(0xFF000000);
  static const Color buttonText = Color(0xFFFFFFFF);
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  static const String routeName = '/login';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isPasswordObscured = true;
  final TextEditingController _identifierController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<LoginCubit>().login(
            _identifierController.text.trim(),
            _passwordController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<LoginCubit>(),
      child: BlocListener<LoginCubit, LoginState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == LoginStatus.success) {
            Navigator.pushReplacementNamed(context, '/sample');
          } else if (state.status == LoginStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? 'Login failed')),
            );
          }
        },
        child: Scaffold( backgroundColor: Colors.white,
          appBar: AppBar(
            leading: const CloseButton(),
            backgroundColor: Colors.white,
            elevation: 0,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 16.0,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildLogoSection(),
                    const SizedBox(height: 8),
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'البريد الإلكتروني أو رقم الهاتف المحمول',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.primaryText,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildTextFormField(
                      hintText: 'XXXXXXXX أو 05example@domain.com',
                      prefixIcon: null,
                      isPassword: false,
                
                      controller: _identifierController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'الرجاء إدخال البريد الإلكتروني أو رقم الهاتف';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'كلمة المرور',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.primaryText,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildTextFormField(
                      hintText: '********',
                      prefixIcon: IconButton(
                        icon: Icon(
                          _isPasswordObscured
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: AppColors.secondaryText,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordObscured = !_isPasswordObscured;
                          });
                        },
                      ),
                      isPassword: true,
                      obscureText: _isPasswordObscured,
                      controller: _passwordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال كلمة المرور';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          'هل نسيت كلمة المرور؟',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.secondaryText,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    BlocBuilder<LoginCubit, LoginState>(
                      builder: (context, state) {
                        final isLoading = state.status == LoginStatus.loading;
                        return ElevatedButton(
                          onPressed: isLoading ? null : _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.buttonBackground,
                            foregroundColor: AppColors.buttonText,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.buttonText,
                                  ),
                                )
                              : const Text(
                                  'تسجيل الدخول',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'ليس لديك حساب؟',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.primaryText,
                          ),
                        ),
                        const SizedBox(width: 4),
                        TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text(
                            'إنشاء حساب جديد',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.primaryText,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoSection() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
Image.asset(
            'assets/images/cosmatica_logo.png',
            width: 120,
            height: 120,
          ),
          Text(
            'COSMETICA',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppColors.accentText,
              letterSpacing: 1.5,
            ),
          ),
          Text(
            'عالم الجمال الفاخر بين يديك',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.secondaryText,
            ),
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }

  Widget _buildTextFormField({
    required String hintText,
    required Widget? prefixIcon,
    required bool isPassword,
    bool obscureText = false,
    TextEditingController? controller,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword ? obscureText : false,
      style: const TextStyle(fontSize: 14, color: AppColors.primaryText),
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,      fillColor: Colors.white,
                      filled: true,
        hintStyle: const TextStyle(fontSize: 14, color: AppColors.secondaryText),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        prefixIcon: prefixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.inputBorder, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.inputBorder, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primaryText, width: 1.5),
        ),
      ),
    );
  }
}
