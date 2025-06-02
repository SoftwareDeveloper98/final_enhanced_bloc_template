import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../../app/di/injector.dart';
import '../../app/router/app_router.dart';
import 'package:clean_bloc_template/core/infrastructure/theme/app_theme.dart';
import 'package:clean_bloc_template/core/infrastructure/theme/theme_cubit.dart';
import 'package:clean_bloc_template/core/translations/l10n/app_localizations.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ThemeCubit>(),
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp.router(
            // Router Configuration
            routerConfig: AppRouter.router,

            // Localization Configuration
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            // locale: Locale('en'), // Optional: Force a specific locale

            // Theme Configuration
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,

            // Other App Configurations
            title: 'Clean BLoC Template', // This won't be localized by default
            debugShowCheckedModeBanner: false, // Disable debug banner
          );
        },
      ),
    );
  }
}

