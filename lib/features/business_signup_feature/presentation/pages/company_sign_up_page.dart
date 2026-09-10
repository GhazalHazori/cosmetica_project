import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../di/injection_container.dart';
import '../../../../features/otp_verification_feature/presentation/pages/otp_verification_screen.dart';
import '../../domain/entities/business_signup_entity.dart';
import '../cubit/business_signup_cubit.dart';
import '../widgets/dotted_border_painter.dart';

class CompanySignUpPage extends StatefulWidget {
  const CompanySignUpPage({super.key});

  static const String routeName = '/business-signup';

  @override
  State<CompanySignUpPage> createState() => _CompanySignUpPageState();
}

class _CompanySignUpPageState extends State<CompanySignUpPage> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String? _selectedFileName;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<BusinessSignupCubit>(),
      child: BlocListener<BusinessSignupCubit, BusinessSignupState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == BusinessSignupStatus.success) {
            Navigator.pushReplacementNamed(
              context,
              OtpVerificationScreen.routeName,
              arguments: _phoneController.text.trim(),
            );
          } else if (state.status == BusinessSignupStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? 'Signup failed')),
            );
          }
        },
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              leading: SizedBox.shrink(),
              actions: [ IconButton(
                icon: const Icon(Icons.arrow_forward, color: Colors.black, size: 28),
                onPressed: () => Navigator.pop(context),
              ),]),
            backgroundColor: Colors.white,
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                   
                    const SizedBox(height: 10),
                    Center(
                      child: Container(
                        width: 100,
                        height: 100,
                        color: const Color(0xFFF5F5F5),
                        child: const Center(
                          child: Text(
                            'COSMETICA',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2.0,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'إنشاء حساب',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'Almarai',
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildInputField(
                      label: 'اسم المستخدم',
                      hint: 'أدخل اسم المستخدم',
                      controller: _usernameController,
                    ),
                    const SizedBox(height: 20),
                    _buildInputField(
                      label: 'البريد الإلكتروني',
                      hint: 'example@mail.com',
                      controller: _emailController,
                      textDirection: TextDirection.ltr,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20),
                    _buildInputField(
                      label: 'رقم الهاتف المحمول',
                      hint: '+966 50 000 0000',
                      controller: _phoneController,
                      textDirection: TextDirection.ltr,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'صورة السجل التجاري',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildFileUploadBox(),
                    const SizedBox(height: 20),
                    _buildInputField(
                      label: 'كلمة المرور',
                      hint: '••••••••',
                      controller: _passwordController,
                      isPassword: true,
                      obscureText: _obscurePassword,
                      onToggleVisibility: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildInputField(
                      label: 'تأكيد كلمة المرور',
                      hint: '••••••••',
                      controller: _confirmPasswordController,
                      isPassword: true,
                      obscureText: _obscureConfirmPassword,
                      onToggleVisibility: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                    const SizedBox(height: 32),
                    BlocBuilder<BusinessSignupCubit, BusinessSignupState>(
                      builder: (context, state) {
                        final isLoading = state.status == BusinessSignupStatus.loading;
                        return SizedBox(
                          height: 52,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : _handleSignup,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                              ),
                              elevation: 0,
                            ),
                            child: isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text(
                                    'إنشاء حساب',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold, fontFamily: 'Almarai',
                                    ),
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
                          'لديك حساب بالفعل؟ ',
                          style: TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'Almarai',),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacementNamed(context, '/login');
                          },
                          child: const Text(
                            'تسجيل الدخول',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFileUploadBox() {
    return InkWell(
      onTap: () {
        // TODO: integrate file picker
      },
      child: CustomPaint(
        painter: const DottedBorderPainter(color: Colors.black, strokeWidth: 1.2, gap: 4),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 1.5),
                ),
                child: const Icon(
                  Icons.file_upload_outlined,
                  color: Colors.black,
                  size: 22,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                _selectedFileName ?? 'اضغط لرفع صورة أو ملف السجل التجاري',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                '( PNG, JPG, PDF الحد الأقصى 10 ميجابايت )',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    required TextEditingController controller,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onToggleVisibility,
    TextDirection? textDirection,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textDirection: textDirection,
          style: const TextStyle(fontSize: 15, color: Colors.black),
          decoration: InputDecoration(
            hintText: hint,
            fillColor: Colors.white,
            filled: true,
            hintTextDirection: textDirection,
            hintStyle: const TextStyle(color: Colors.black26, fontSize: 14),
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 1.5),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 2),
            ),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      color: Colors.grey,
                    ),
                    onPressed: onToggleVisibility,
                  )
                : null,
          ),
        ),
      ],
    );
  }

  void _handleSignup() {
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (username.isEmpty ||
        email.isEmpty ||
        phone.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء ملء جميع الحقول')),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('كلمتا المرور غير متطابقتين')),
      );
      return;
    }

    context.read<BusinessSignupCubit>().businessSignup(
          BusinessSignupEntity(
            username: username,
            email: email,
            phone: phone,
            password: password,
            confirmPassword: confirmPassword,
            agreeToTerms: true,
          ),
        );
  }
}
