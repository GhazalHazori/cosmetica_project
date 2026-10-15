import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/phone_utils.dart';
import '../../../../core/widgets/country_code_picker.dart';
import '../../../../core/widgets/otp_code_field.dart';
import '../../../login_feature/presentation/pages/login_page.dart';
import '../cubit/reset_password_cubit.dart';

/// Phone → code → new password, on one route. Expects a
/// [ResetPasswordCubit] above it (provided by AppRouter).
class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  static const String routeName = '/reset-password';

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  static const int _codeLength = 6;
  /// How long a code stays valid before it can be resent: 2 minutes.
  static const int _resendSeconds = 120;

  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  CountryCode _countryCode = kDefaultCountryCode;
  String _code = '';

  // Bumped to clear the code boxes after a resend.
  int _codeFieldVersion = 0;

  Timer? _timer;
  int _secondsRemaining = 0;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _timer?.cancel();
    _phoneController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _secondsRemaining = _resendSeconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining <= 1) {
        timer.cancel();
      }
      setState(() => _secondsRemaining--);
    });
  }

  String get _formattedTime {
    final minutes = (_secondsRemaining ~/ 60).toString().padLeft(2, '0');
    final seconds = (_secondsRemaining % 60).toString().padLeft(2, '0');
    return '$minutes : $seconds';
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _goBack(BuildContext context) {
    if (!context.read<ResetPasswordCubit>().back()) {
      Navigator.pop(context);
    }
  }

  void _handleSendCode(BuildContext context) {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<ResetPasswordCubit>().requestCode(
          composeInternationalPhone(
            _countryCode.dialCode,
            _phoneController.text,
          ),
        );
  }

  void _handleVerify(BuildContext context) {
    if (_code.length != _codeLength) {
      _showMessage(AppLocalizations.of(context).tr('reset.code_required'));
      return;
    }
    context.read<ResetPasswordCubit>().verifyCode(_code);
  }

  void _handleSave(BuildContext context) {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context
        .read<ResetPasswordCubit>()
        .completeReset(_newPasswordController.text);
  }

  Future<void> _selectCountryCode() async {
    final CountryCode? selected = await showCountryCodePicker(context);
    if (selected == null || !mounted) return;
    setState(() => _countryCode = selected);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        final l10n = AppLocalizations.of(context);
        switch (state.status) {
          case ResetPasswordStatus.codeSent:
            setState(() {
              _code = '';
              _codeFieldVersion++;
            });
            _startTimer();
            _showMessage(l10n.tr('reset.code_sent'));
            break;
          case ResetPasswordStatus.completed:
            _showMessage(l10n.tr('reset.completed'));
            Navigator.pushNamedAndRemoveUntil(
              context,
              LoginPage.routeName,
              (route) => false,
            );
            break;
          case ResetPasswordStatus.failure:
            final message = state.errorMessage;
            _showMessage(
              message == null || message.isEmpty
                  ? l10n.tr('auth.error_generic')
                  : message,
            );
            break;
          case ResetPasswordStatus.initial:
          case ResetPasswordStatus.loading:
            break;
        }
      },
      builder: (context, state) {
        final isLoading = state.status == ResetPasswordStatus.loading;

        return PopScope(
          canPop: state.step == ResetPasswordStep.phone,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) context.read<ResetPasswordCubit>().back();
          },
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              backgroundColor: Colors.white,
              body: SafeArea(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 450),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                            child: IconButton(
                              icon: const Icon(
                                Icons.arrow_forward,
                                color: Colors.black,
                                size: 24,
                              ),
                              onPressed: () => _goBack(context),
                            ),
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.08,
                            ),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(height: 10),
                                  Image.asset(
                                    'assets/images/cosmatica_logo.png',
                                    width: 110,
                                    height: 110,
                                  ),
                                  const SizedBox(height: 28),
                                  ...switch (state.step) {
                                    ResetPasswordStep.phone =>
                                      _buildPhoneStep(context, isLoading),
                                    ResetPasswordStep.code =>
                                      _buildCodeStep(context, state, isLoading),
                                    ResetPasswordStep.newPassword =>
                                      _buildNewPasswordStep(
                                        context,
                                        isLoading,
                                      ),
                                  },
                                  const SizedBox(height: 20),
                                  GestureDetector(
                                    onTap: () => Navigator.pop(context),
                                    child: const Text(
                                      'تذكرت كلمة المرور؟ تسجيل الدخول',
                                      style: TextStyle(
                                        fontSize: 12.5,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        decoration: TextDecoration.underline,
                                        fontFamily: 'Almarai',
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildPhoneStep(BuildContext context, bool isLoading) {
    final l10n = AppLocalizations.of(context);
    return [
      _buildTitle(l10n.tr('reset.phone_title')),
      const SizedBox(height: 10),
      _buildSubtitle(l10n.tr('reset.phone_subtitle')),
      const SizedBox(height: 30),
      TextFormField(
        controller: _phoneController,
        keyboardType: TextInputType.phone,
        textDirection: TextDirection.ltr,
        style: const TextStyle(fontSize: 14),
        validator: (value) => value == null || value.trim().isEmpty
            ? l10n.tr('reset.phone_required')
            : null,
        decoration: _inputDecoration(
          label: l10n.tr('reset.phone_label'),
          hint: '5X XXX XXXX',
          prefix: CountryCodeSelector(
            country: _countryCode,
            onTap: _selectCountryCode,
          ),
        ),
      ),
      const SizedBox(height: 28),
      _buildPrimaryButton(
        label: l10n.tr('reset.send_code'),
        onPressed: isLoading ? null : () => _handleSendCode(context),
      ),
    ];
  }

  List<Widget> _buildCodeStep(
    BuildContext context,
    ResetPasswordState state,
    bool isLoading,
  ) {
    final l10n = AppLocalizations.of(context);
    final canResend = _secondsRemaining <= 0 && !isLoading;
    return [
      _buildTitle(l10n.tr('reset.code_title')),
      const SizedBox(height: 10),
      _buildSubtitle(l10n.tr('reset.code_subtitle')),
      const SizedBox(height: 4),
      Text(
        state.phone,
        textDirection: TextDirection.ltr,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      const SizedBox(height: 30),
      OtpCodeField(
        key: ValueKey(_codeFieldVersion),
        length: _codeLength,
        onChanged: (code) => _code = code,
      ),
      const SizedBox(height: 24),
      if (_secondsRemaining > 0)
        Text(
          _formattedTime,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            letterSpacing: 2.0,
            fontFamily: 'Almarai',
          ),
        ),
      const SizedBox(height: 16),
      Text(
        l10n.tr('reset.didnt_receive'),
        style: const TextStyle(fontSize: 13, color: Colors.grey),
      ),
      const SizedBox(height: 6),
      GestureDetector(
        onTap: canResend
            ? () => context.read<ResetPasswordCubit>().resendCode()
            : null,
        child: Text(
          l10n.tr('reset.resend'),
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: canResend ? Colors.black : Colors.grey,
            decoration: TextDecoration.underline,
            decorationColor: canResend ? Colors.black : Colors.grey,
            fontFamily: 'Almarai',
          ),
        ),
      ),
      const SizedBox(height: 28),
      _buildPrimaryButton(
        label: l10n.tr('reset.verify'),
        onPressed: isLoading ? null : () => _handleVerify(context),
      ),
    ];
  }

  List<Widget> _buildNewPasswordStep(BuildContext context, bool isLoading) {
    return [
      _buildTitle('إعادة تعيين كلمة المرور'),
      const SizedBox(height: 10),
      _buildSubtitle(
        'أدخل كلمة المرور الجديدة الخاصة بحسابك، احرص أن\nتتكون من 8 خانات على الأقل لضمان الأمان.',
      ),
      const SizedBox(height: 30),
      _buildPasswordField(
        label: 'كلمة المرور الجديدة *',
        controller: _newPasswordController,
        obscureText: _obscureNewPassword,
        onToggleObscure: () => setState(() {
          _obscureNewPassword = !_obscureNewPassword;
        }),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'الرجاء إدخال كلمة المرور الجديدة';
          }
          if (value.length < 8) {
            return 'كلمة المرور يجب أن تكون 8 خانات على الأقل';
          }
          if (!RegExp('[A-Z]').hasMatch(value) ||
              !RegExp('[0-9]').hasMatch(value)) {
            return 'كلمة المرور يجب أن تحتوي على حرف كبير ورقم واحد على الأقل';
          }
          return null;
        },
      ),
      const SizedBox(height: 20),
      _buildPasswordField(
        label: 'تأكيد كلمة المرور الجديدة *',
        controller: _confirmPasswordController,
        obscureText: _obscureConfirmPassword,
        onToggleObscure: () => setState(() {
          _obscureConfirmPassword = !_obscureConfirmPassword;
        }),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'الرجاء تأكيد كلمة المرور الجديدة';
          }
          if (value != _newPasswordController.text) {
            return 'كلمتا المرور غير متطابقتين';
          }
          return null;
        },
      ),
      const SizedBox(height: 24),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF9F9F9),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        child: const Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.check_circle_outline,
                  color: Colors.black,
                  size: 16,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'أن لا تقل عن 8 أحرف وأرقام',
                    style: TextStyle(fontSize: 11.5, color: Colors.grey),
                  ),
                ),
              ],
            ),
            SizedBox(height: 6),
            Row(
              children: [
                Icon(
                  Icons.radio_button_unchecked,
                  color: Colors.grey,
                  size: 16,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'تحتوي على حرف كبير ورقم واحد على الأقل',
                    style: TextStyle(fontSize: 11.5, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      const SizedBox(height: 28),
      _buildPrimaryButton(
        label: 'حفظ كلمة المرور الجديدة',
        onPressed: isLoading ? null : () => _handleSave(context),
      ),
    ];
  }

  Widget _buildTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildSubtitle(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 12, color: Colors.grey, height: 1.4),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildPrimaryButton({
    required String label,
    required VoidCallback? onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          elevation: 0,
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            fontFamily: 'Almarai',
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    String? hint,
    Widget? prefix,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      fillColor: Colors.white,
      filled: true,
      labelStyle: const TextStyle(color: Colors.black, fontSize: 13),
      hintStyle: const TextStyle(color: Colors.black26, fontSize: 14),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      prefixIcon: prefix,
      prefixIconConstraints: prefix == null
          ? null
          : const BoxConstraints(minWidth: 0, minHeight: 0),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        borderSide: const BorderSide(color: Colors.black, width: 1.2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        borderSide: const BorderSide(color: Colors.black, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        borderSide: const BorderSide(color: Colors.red, width: 1.2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
    );
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required bool obscureText,
    required VoidCallback onToggleObscure,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      textAlign: TextAlign.right,
      style: const TextStyle(fontSize: 14),
      validator: validator,
      decoration: _inputDecoration(label: label).copyWith(
        prefixIcon: IconButton(
          icon: Icon(
            obscureText
                ? Icons.remove_red_eye_outlined
                : Icons.visibility_off_outlined,
            color: Colors.grey,
            size: 20,
          ),
          onPressed: onToggleObscure,
        ),
      ),
    );
  }
}
