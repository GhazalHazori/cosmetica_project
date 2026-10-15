import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

/// The app's Cosmetica loading animation.
class AppLoader extends StatelessWidget {
  const AppLoader({super.key, this.size = 170});

  static const String asset = 'assets/lottie/loader_cosmetica.json';

  final double size;

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      asset,
      width: size,
      height: size,
      fit: BoxFit.contain,
      repeat: true,
    );
  }
}

/// Shows [AppLoader] over the whole app while [isLoading] is true for the
/// state of cubit [C], blocking taps until the API answers.
///
/// The loader goes on the root overlay, so it also covers app bars and the
/// bottom navigation bar when [child] is a tab. Once shown it stays for at
/// least [minimumDuration], so a fast response does not just flash it — also
/// across the navigation that follows a success.
///
/// ```dart
/// AppLoadingOverlay<LoginCubit, LoginState>(
///   isLoading: (state) => state.status == LoginStatus.loading,
///   child: Scaffold(...),
/// )
/// ```
class AppLoadingOverlay<C extends StateStreamable<S>, S>
    extends StatefulWidget {
  const AppLoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.minimumDuration = defaultMinimumDuration,
  });

  static const Duration defaultMinimumDuration = Duration(milliseconds: 1500);

  final bool Function(S state) isLoading;
  final Widget child;
  final Duration minimumDuration;

  @override
  State<AppLoadingOverlay<C, S>> createState() =>
      _AppLoadingOverlayState<C, S>();
}

class _AppLoadingOverlayState<C extends StateStreamable<S>, S>
    extends State<AppLoadingOverlay<C, S>> {
  OverlayEntry? _entry;
  DateTime? _shownAt;
  Timer? _hideTimer;

  @override
  void initState() {
    super.initState();
    // The cubit may already be loading when this widget mounts.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _sync(context.read<C>().state);
    });
  }

  @override
  void dispose() {
    // Already hiding (e.g. success, then navigation): the entry lives on the
    // root overlay, so it finishes its minimum time over the next screen and
    // the pending timer removes it. Otherwise the screen left mid-request:
    // remove it now.
    final entry = _entry;
    if (_hideTimer == null && entry != null) _remove(entry);
    super.dispose();
  }

  void _sync(S state) => widget.isLoading(state) ? _show() : _hide();

  void _show() {
    // Loading again before a pending hide: keep the loader up.
    _hideTimer?.cancel();
    _hideTimer = null;
    if (_entry != null) return;
    _entry = OverlayEntry(builder: (_) => const _LoaderBarrier());
    _shownAt = DateTime.now();
    Overlay.of(context, rootOverlay: true).insert(_entry!);
  }

  void _hide() {
    final entry = _entry;
    if (entry == null || _hideTimer != null) return;

    final elapsed = DateTime.now().difference(_shownAt ?? DateTime.now());
    final remaining = widget.minimumDuration - elapsed;
    if (remaining <= Duration.zero) {
      _remove(entry);
    } else {
      _hideTimer = Timer(remaining, () => _remove(entry));
    }
  }

  void _remove(OverlayEntry entry) {
    _hideTimer = null;
    if (identical(_entry, entry)) {
      _entry = null;
      _shownAt = null;
    }
    entry.remove();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<C, S>(
      listenWhen: (previous, current) =>
          widget.isLoading(previous) != widget.isLoading(current),
      listener: (_, state) => _sync(state),
      child: widget.child,
    );
  }
}

class _LoaderBarrier extends StatelessWidget {
  const _LoaderBarrier();

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ModalBarrier(
          dismissible: false,
          color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.8),
        ),
        const Center(child: AppLoader()),
      ],
    );
  }
}
