import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

import '../../../../di/injection_container.dart';
import '../../../home_feature/presentation/pages/main_layout_screen.dart';
import '../../../login_feature/presentation/pages/login_page.dart';
import '../../../otp_verification_feature/presentation/pages/otp_verification_screen.dart';
import '../cubit/splash_cubit.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  static const String routeName = '/splash';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SplashCubit>()..start(),
      child: const SplashView(),
    );
  }
}

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with TickerProviderStateMixin {
  late final AnimationController _controller;
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    debugPrint("🎬 [Splash] initState called");

    _controller = AnimationController(vsync: this);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        debugPrint("🏁 [Splash] Lottie reached end.");
        _navigateToNextScreen();
      }
    });

    Future.delayed(const Duration(seconds: 8), () {
      if (mounted && !_hasNavigated) {
        debugPrint("⏰ [Splash] Safety timer reached, triggering navigation.");
        _navigateToNextScreen();
      }
    });
  }

  void _navigateToNextScreen() {
    if (_hasNavigated) return;
    _hasNavigated = true;

    debugPrint("🚀 [Splash] Navigating to next screen");

    if (mounted) {
      context.read<SplashCubit>().onVideoCompleted();
    }
  }

  @override
  void dispose() {
    debugPrint("🧹 [Splash] Disposing controller...");
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        debugPrint("🔔 [Splash] State changed to: ${state.status}");
        if (state.status == SplashStatus.completed) {
          final pending = state.pendingVerification;
          final (String route, Object? arguments) = switch (state.destination) {
            SplashDestination.home => (MainLayoutScreen.routeName, null),
            SplashDestination.login => (LoginPage.routeName, null),
            SplashDestination.otpVerification => (
                OtpVerificationScreen.routeName,
                OtpVerificationArgs(
                  phoneNumber: pending!.phoneNumber,
                  isBusiness: pending.isBusiness,
                  codeSentAt: pending.codeSentAt,
                ),
              ),
          };
          Navigator.pushNamedAndRemoveUntil(
            context,
            route,
            (route) => false,
            arguments: arguments,
          );
        }
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Lottie.asset(
              'assets/lottie/cosmetica_lottiee.json',
              controller: _controller,
              fit: BoxFit.contain,
              onLoaded: (composition) {
                debugPrint("✅ [Splash] Lottie Loaded Successfully");
                _controller.duration = composition.duration;
                _controller.forward();

                if (mounted) {
                  context.read<SplashCubit>().onVideoInitialized();
                }
              },
              errorBuilder: (context, error, stackTrace) {
                debugPrint("❌ [Splash] Lottie Loading Failed: $error");
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _navigateToNextScreen();
                });
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
  }
}