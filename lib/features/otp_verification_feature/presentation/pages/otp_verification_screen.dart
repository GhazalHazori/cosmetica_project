import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/widgets/otp_code_field.dart';
import '../../../login_feature/presentation/pages/login_page.dart';
import '../../domain/entities/otp_verification_entity.dart';
import '../cubit/otp_verification_cubit.dart';
import '../../../../core/theme/app_spacing.dart';

/// Route arguments for [OtpVerificationScreen].
class OtpVerificationArgs {
  final String phoneNumber;

  /// A business account stays pending after verification until staff
  /// review its commercial register.
  final bool isBusiness;

  /// When the current code was sent: right after registering, or the saved
  /// time when the app reopens here. `null` when [sendCode] is set.
  final DateTime? codeSentAt;

  /// Sends a code on open: resuming an unverified account from sign-in or
  /// from a second registration with the same number.
  final bool sendCode;

  const OtpVerificationArgs({
    required this.phoneNumber,
    this.isBusiness = false,
    this.codeSentAt,
    this.sendCode = false,
  });
}

class OtpVerificationScreen extends StatefulWidget {
  final OtpVerificationArgs args;

  const OtpVerificationScreen({super.key, required this.args});

  static const String routeName = '/otp-verification';

  factory OtpVerificationScreen.fromRouteSettings(RouteSettings settings) {
    final args = settings.arguments as OtpVerificationArgs?;
    return OtpVerificationScreen(
      args: args ?? const OtpVerificationArgs(phoneNumber: ''),
    );
  }

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  static const int _codeLength = 6;

  /// How long a code stays valid before it can be resent: 2 minutes.
  static const int _codeValiditySeconds = 120;

  String _code = '';

  Timer? _timer;
  int _secondsRemaining = 0;

  String get _phoneNumber => widget.args.phoneNumber;

  @override
  void initState() {
    super.initState();
    // Continue the code's real validity window, e.g. after reopening the app.
    final codeSentAt = widget.args.codeSentAt;
    if (codeSentAt != null) {
      final elapsed = DateTime.now().difference(codeSentAt).inSeconds;
      _startTimer(_codeValiditySeconds - elapsed);
    }
    context.read<OtpVerificationCubit>().start(
          phoneNumber: _phoneNumber,
          isBusiness: widget.args.isBusiness,
          codeSentAt: codeSentAt,
          sendCode: widget.args.sendCode,
        );
  }

  void _startTimer([int seconds = _codeValiditySeconds]) {
    _secondsRemaining = seconds.clamp(0, _codeValiditySeconds);
    _timer?.cancel();
    if (_secondsRemaining == 0) return;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  String get _formattedTime {
    final minutes = (_secondsRemaining ~/ 60).toString().padLeft(2, '0');
    final seconds = (_secondsRemaining % 60).toString().padLeft(2, '0');
    return '$minutes : $seconds';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OtpVerificationCubit, OtpVerificationState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        final l10n = AppLocalizations.of(context);
        final messenger = ScaffoldMessenger.of(context);
        switch (state.status) {
          case OtpVerificationStatus.success:
            // Verification returns no tokens, so the user signs in next.
            messenger.showSnackBar(
              SnackBar(
                content: Text(
                  l10n.tr(
                    widget.args.isBusiness
                        ? 'auth.business_pending_review'
                        : 'auth.verified_sign_in',
                  ),
                ),
              ),
            );
            Navigator.pushNamedAndRemoveUntil(
              context,
              LoginPage.routeName,
              (route) => false,
            );
            break;
          case OtpVerificationStatus.resent:
            // A new code: its validity window starts now.
            setState(_startTimer);
            messenger.showSnackBar(
              SnackBar(content: Text(l10n.tr('auth.otp_resent'))),
            );
            break;
          case OtpVerificationStatus.failure:
            final message = state.errorMessage;
            messenger.showSnackBar(
              SnackBar(
                content: Text(
                  message == null || message.isEmpty
                      ? l10n.tr('auth.error_generic')
                      : message,
                ),
              ),
            );
            break;
          case OtpVerificationStatus.initial:
          case OtpVerificationStatus.loading:
            break;
        }
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 20.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
                  Column(
                    children: [
                      const Text(
                        'C O S M E T I C A',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 4.0,
                          color: Colors.black,
                          fontFamily: 'Almarai',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 40,
                        height: 1.5,
                        color: Colors.grey.shade400,
                      ),
                    ],
                  ),
                  const SizedBox(height: 48),
                  const Text(
                    'رمز التحقق',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: 'Almarai',
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'لقد أرسلنا رمز التحقق المكون من 6 أرقام إلى رقم هاتفك المسجل لدينا. يرجى إدخاله للمتابعة.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: Colors.grey,
                        fontFamily: 'Almarai',
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  OtpCodeField(
                    length: _codeLength,
                    onChanged: (code) => _code = code,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    _formattedTime,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      letterSpacing: 2.0,
                      fontFamily: 'Almarai',
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'لم يصلك الرمز؟',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                      fontFamily: 'Almarai',
                    ),
                  ),
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap:
                        _secondsRemaining == 0
                            ? () => context
                                .read<OtpVerificationCubit>()
                                .resendOtp(_phoneNumber)
                            : null,
                    child: Column(
                      children: [
                        Text(
                          'إعادة إرسال الرمز',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color:
                                _secondsRemaining == 0
                                    ? Colors.black
                                    : Colors.black87,
                            fontFamily: 'Almarai',
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.black
                          ),
                        ),
                        // Container(width: 130, height: 1, color: Colors.black),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: double.infinity,
                    height: 52,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child:
                        BlocBuilder<OtpVerificationCubit, OtpVerificationState>(
                          builder: (context, state) {
                            final isLoading =
                                state.status == OtpVerificationStatus.loading;
                            return ElevatedButton(
                              onPressed: isLoading ? null : _handleVerify,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                                ),
                                elevation: 0,
                              ),
                              child:
                                  const Text(
                                        'تأكيد',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Almarai',
                                        ),
                                      ),
                            );
                          },
                        ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: _backToLogin,
                    child: Text(
                      AppLocalizations.of(context).tr('otp.back_to_login'),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        decoration: TextDecoration.underline,
                        fontFamily: 'Almarai',
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Leaves this verification for good: the app stops reopening on it.
  Future<void> _backToLogin() async {
    final navigator = Navigator.of(context);
    await context.read<OtpVerificationCubit>().abandon();
    navigator.pushNamedAndRemoveUntil(LoginPage.routeName, (route) => false);
  }

  void _handleVerify() {
    final otp = _code;

    if (otp.length != _codeLength) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('الرجاء إدخال رمز التحقق المكون من 6 أرقام'),
        ),
      );
      return;
    }

    context.read<OtpVerificationCubit>().verifyOtp(
      OtpVerificationEntity(phoneNumber: _phoneNumber, otpCode: otp),
    );
  }
}
