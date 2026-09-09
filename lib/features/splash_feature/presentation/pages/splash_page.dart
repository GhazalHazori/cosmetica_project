import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

import '../../../../di/injection_container.dart';
import '../cubit/splash_cubit.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  static const String routeName = '/splash';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SplashCubit>(),
      child: const SplashView(),
    );
  }
}

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  VideoPlayerController? _controller;
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeVideo();
    });
  }

  Future<void> _initializeVideo() async {
    _controller = VideoPlayerController.asset('assets/video/cosmetica_flutter_android.mp4');

    try {
      await _controller!.initialize();
      _controller!.setLooping(false);

      _controller!.addListener(_videoListener);

      if (mounted) {
        setState(() {});
        await _controller!.play();
        context.read<SplashCubit>().onVideoInitialized();
      }
    } catch (e) {
      _navigateToNextScreen();
    }
  }

  void _videoListener() {
    if (_controller != null && _controller!.value.isInitialized && !_hasNavigated) {
      final position = _controller!.value.position;
      final duration = _controller!.value.duration;

      // التأكد من الوصول للنهاية أو تجاوزها
      if (position >= duration && duration > Duration.zero) {
        _navigateToNextScreen();
      }
    }
  }

  void _navigateToNextScreen() {
    if (_hasNavigated) return;
    _hasNavigated = true;

    // إزالة الـ Listener وإيقاف المشغل فوراً لمنع أي استدعاءات إضافية أثناء التوجيه
    if (_controller != null) {
      _controller!.removeListener(_videoListener);
      _controller!.pause();
    }

    if (mounted) {
      context.read<SplashCubit>().onVideoCompleted();
    }
  }

  @override
  void dispose() {
    if (_controller != null) {
      _controller!.removeListener(_videoListener);
      _controller!.dispose();
      _controller = null;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == SplashStatus.completed) {
          Navigator.pushReplacementNamed(context, '/login');
        }
      },
      child: Scaffold(
        // backgroundColor: Colors.white,
        body: _controller != null && _controller!.value.isInitialized
            ? SizedBox.expand(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _controller!.value.size.width,
                    height: _controller!.value.size.height,
                    child: VideoPlayer(_controller!),
                  ),
                ),
              )
            : const SizedBox.expand(),
      ),
    );
  }
}