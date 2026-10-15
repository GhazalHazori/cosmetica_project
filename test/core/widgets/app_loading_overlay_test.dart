import 'package:cosmetica_project/core/widgets/app_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class _LoadingCubit extends Cubit<bool> {
  _LoadingCubit(super.initialState);

  void set(bool loading) => emit(loading);
}

const _minimum = AppLoadingOverlay.defaultMinimumDuration;

Future<_LoadingCubit> _pump(WidgetTester tester, {bool initial = false}) async {
  final cubit = _LoadingCubit(initial);
  await tester.pumpWidget(
    MaterialApp(
      home: BlocProvider.value(
        value: cubit,
        child: Scaffold(
          body: AppLoadingOverlay<_LoadingCubit, bool>(
            isLoading: (loading) => loading,
            child: const Text('content'),
          ),
          bottomNavigationBar: const Text('nav'),
        ),
      ),
    ),
  );
  await tester.pump();
  return cubit;
}

/// The listener reacts during the next frame; the overlay rebuilds after it.
Future<void> _settle(WidgetTester tester) async {
  await tester.pump();
  await tester.pump();
}

void main() {
  testWidgets('shows the loader while loading and removes it after',
      (tester) async {
    final cubit = await _pump(tester);
    expect(find.byType(AppLoader), findsNothing);

    cubit.set(true);
    await _settle(tester);
    expect(find.byType(AppLoader), findsOneWidget);
    // Drawn on the root overlay: it blocks the whole screen, nav bar included.
    expect(find.byType(ModalBarrier), findsWidgets);

    cubit.set(false);
    await _settle(tester);
    await tester.pump(_minimum);
    expect(find.byType(AppLoader), findsNothing);
  });

  testWidgets('a fast response keeps the loader for the minimum duration',
      (tester) async {
    final cubit = await _pump(tester);

    cubit.set(true);
    await _settle(tester);
    cubit.set(false);
    await _settle(tester);

    await tester.pump(_minimum - const Duration(milliseconds: 200));
    expect(find.byType(AppLoader), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 300));
    expect(find.byType(AppLoader), findsNothing);
  });

  testWidgets('loading again before the hide keeps a single loader',
      (tester) async {
    final cubit = await _pump(tester);

    cubit.set(true);
    await _settle(tester);
    cubit.set(false);
    await _settle(tester);
    cubit.set(true);
    await _settle(tester);

    await tester.pump(_minimum * 2);
    expect(find.byType(AppLoader), findsOneWidget);

    cubit.set(false);
    await _settle(tester);
    await tester.pump(_minimum);
  });

  testWidgets('shows the loader when the cubit is already loading',
      (tester) async {
    final cubit = await _pump(tester, initial: true);
    expect(find.byType(AppLoader), findsOneWidget);

    cubit.set(false);
    await _settle(tester);
    await tester.pump(_minimum);
  });

  testWidgets('leaving mid-request removes the loader at once',
      (tester) async {
    final cubit = await _pump(tester);
    cubit.set(true);
    await _settle(tester);

    await tester.pumpWidget(const MaterialApp(home: Text('login')));
    await tester.pump();
    expect(find.byType(AppLoader), findsNothing);
  });

  testWidgets('after success it finishes its minimum time over the next screen',
      (tester) async {
    final navigatorKey = GlobalKey<NavigatorState>();
    final cubit = _LoadingCubit(false);
    await tester.pumpWidget(
      MaterialApp(
        navigatorKey: navigatorKey,
        home: BlocProvider.value(
          value: cubit,
          child: AppLoadingOverlay<_LoadingCubit, bool>(
            isLoading: (loading) => loading,
            child: const Text('form'),
          ),
        ),
      ),
    );
    await tester.pump();

    cubit.set(true);
    await _settle(tester);
    cubit.set(false);
    await _settle(tester);
    navigatorKey.currentState!.pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => const Text('next step')),
      (_) => false,
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.byType(AppLoader), findsOneWidget);

    await tester.pump(_minimum);
    expect(find.byType(AppLoader), findsNothing);
    expect(find.text('next step'), findsOneWidget);
  });
}
