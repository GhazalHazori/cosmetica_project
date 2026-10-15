import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/utils/phone_utils.dart';
import '../../../../core/widgets/app_action_bottom_sheet.dart';
import '../../../../core/widgets/app_loader.dart';
import '../../../../core/widgets/country_code_picker.dart';
import '../../../../di/injection_container.dart';
import '../../../home_feature/presentation/pages/main_layout_screen.dart';
import '../../../otp_verification_feature/presentation/pages/otp_verification_screen.dart';
import '../../../reset_password_feature/presentation/pages/reset_password_screen.dart';
import '../cubit/login_cubit.dart';
import '../widgets/account_type_bottom_sheet.dart';
import '../../../../core/theme/app_spacing.dart';

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
  CountryCode _countryCode = kDefaultCountryCode;
  final TextEditingController _identifierController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// [context] must be below the page's BlocProvider.
  void _handleLogin(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<LoginCubit>().login(
            composeInternationalPhone(
              _countryCode.dialCode,
              _identifierController.text,
            ),
            _passwordController.text,
          );
    }
  }

  /// The account exists but is not active: offer to verify its number (a
  /// code is sent only if it is awaiting verification).
  Future<void> _offerVerification(BuildContext context, String phone) async {
    final l10n = AppLocalizations.of(context);
    final navigator = Navigator.of(context);
    final verify = await showAppActionBottomSheet<bool>(
      context,
      icon: Icons.verified_user_outlined,
      title: l10n.tr('pending.title'),
      message: l10n.tr('pending.message'),
      actions: [
        AppSheetAction(
          label: l10n.tr('pending.verify'),
          value: true,
          isPrimary: true,
        ),
        AppSheetAction(label: l10n.tr('common.close'), value: false),
      ],
    );
    if (verify != true) return;
    navigator.pushNamed(
      OtpVerificationScreen.routeName,
      arguments: OtpVerificationArgs(phoneNumber: phone, sendCode: true),
    );
  }

  Future<void> _selectCountryCode() async {
    final CountryCode? selected = await showCountryCodePicker(context);
    if (selected == null || !mounted) {
      return;
    }
    setState(() => _countryCode = selected);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<LoginCubit>(),
      child: BlocListener<LoginCubit, LoginState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == LoginStatus.success) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              MainLayoutScreen.routeName,
              (route) => false,
            );
          } else if (state.status == LoginStatus.accountPending) {
            _offerVerification(context, state.identifier ?? '');
          } else if (state.status == LoginStatus.failure) {
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
        child: AppLoadingOverlay<LoginCubit, LoginState>(
          isLoading: (state) => state.status == LoginStatus.loading,
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
                        'رقم الهاتف المحمول',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.primaryText,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildTextFormField(
                      hintText: '5XXXXXXXX',
                      prefixIcon: CountryCodeSelector(
                        country: _countryCode,
                        onTap: _selectCountryCode,
                      ),
                      isPassword: false,
                      keyboardType: TextInputType.phone,
                      textDirection: TextDirection.ltr,
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
                        onPressed: () => Navigator.pushNamed(
                          context,
                          ResetPasswordScreen.routeName,
                        ),
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
                          onPressed:
                              isLoading ? null : () => _handleLogin(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.buttonBackground,
                            foregroundColor: AppColors.buttonText,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                                 borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                                  'تسجيل الدخول',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                      fontFamily: 'Almarai',
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
                           onPressed: () => showAccountTypeBottomSheet(context),
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
                              fontFamily: 'Almarai',
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
          // Text(
          //   'COSMETICA',
          //   style: TextStyle(
          //     fontSize: 32,
          //     fontWeight: FontWeight.bold,
          //     color: AppColors.accentText,
          //     letterSpacing: 1.5,
          //   ),
          // ),
          Text(
            'جمالك موثوق ، جودة مضمونة ، توفير دائم.',
            style: TextStyle(
              fontSize: 14,
              color:Color(0xff64748B),
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
    TextInputType? keyboardType,
    TextDirection? textDirection,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword ? obscureText : false,
      keyboardType: keyboardType,
      textDirection: textDirection,
      style: const TextStyle(fontSize: 14, color: AppColors.primaryText),
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,      fillColor: Colors.white,
                      filled: true,
        hintStyle: const TextStyle(fontSize: 14, color: AppColors.secondaryText),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        prefixIcon: prefixIcon,
        border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: const BorderSide(color: AppColors.inputBorder, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
                 borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: const BorderSide(color: AppColors.inputBorder, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: const BorderSide(color: AppColors.primaryText, width: 1.5),
        ),
      ),
    );
  }
}
