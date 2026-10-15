import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/localization/app_localizations.dart';
import 'core/localization/localization_cubit.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_cubit.dart';
import 'routes/app_router.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = AppRouter();

    return BlocBuilder<LocalizationCubit, LocalizationState>(
      builder: (context, localeState) {
        return BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, themeState) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Cosmetica',
              locale: localeState.locale,
              supportedLocales: AppLocalizations.supportedLocales,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              localeResolutionCallback:
                  AppLocalizations.localeResolutionCallback,
              builder: (context, child) {
                final textDirection = localeState.locale.languageCode == 'ar'
                    ? TextDirection.rtl
                    : TextDirection.ltr;

                return AnnotatedRegion<SystemUiOverlayStyle>(
                  value: const SystemUiOverlayStyle(
                    statusBarColor: Colors.white,
                    statusBarIconBrightness: Brightness.dark,
                    systemNavigationBarColor: Colors.white,
                    systemNavigationBarIconBrightness: Brightness.dark,
                  ),
                  child: Directionality(
                    textDirection: textDirection,
                    child: child ?? const SizedBox.shrink(),
                  ),
                );
              },
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeState.themeMode,
              onGenerateRoute: router.onGenerateRoute,
              initialRoute: AppRouter.initialRoute,
            );
          },
        );
      },
    );
  }
}


