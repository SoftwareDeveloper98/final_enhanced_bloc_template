import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Add if Bloc is used early
import 'core/di/service_locator.dart';
import 'features/auth/presentation/pages/login_page.dart'; // Import LoginPage
import 'shared/themes/app_theme.dart'; // Import AppTheme

// Dummy App widget for now
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Enterprise Scaffold',
      theme: AppTheme.lightTheme, // Example from shared
      darkTheme: AppTheme.darkTheme, // Example from shared
      // themeMode: ThemeMode.system, // Or from a theme cubit
      home: const LoginPage(), // Set LoginPage as home for now
    );
  }
}

Future<void> mainCommon(String environment) async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies(environment: environment);

  // Initialize and start UI Performance Monitor
  // final uiMonitor = sl<UiPerformanceMonitor>(); // Get from DI (ensure sl is imported/accessible)
  // uiMonitor.startMonitoring(); // Start after app is somewhat initialized
  // Consider calling uiMonitor.dispose() in a suitable lifecycle hook if your app has one.
  // For example, if MyApp had a dispose method, or if you have a global app lifecycle manager.

  // --- Privacy Consent Service Initialization and Checks ---
  // Ensure DI is configured and PrivacyConsentService is registered with `registerSingletonAsync`.
  // `configureDependencies` should handle awaiting `sl.allReady()` or specific services if needed,
  // or you can do it here. For instance, if `app_injector.dart` `configureDependencies` is:
  //   `Future<void> configureDependencies(String environment) async { ... await sl.allReady(); }`
  // then `sl.isReady<PrivacyConsentService>()` would not be strictly necessary here if `allReady` covers it.
  // However, explicit check can be clearer if `configureDependencies` doesn't guarantee all async singletons are ready.

  // await sl.isReady<PrivacyConsentService>(); // Ensure SharedPreferences is ready via the async singleton
  // final privacyConsentService = sl<PrivacyConsentService>();

  // // Example: Show consent dialog if needed (navigatorKey.currentContext might be null this early)
  // // This might need to be called after the first frame or when a navigatorKey.currentContext is available.
  // // Consider a flag or post-frame callback if context is needed immediately for navigation.
  // if (!privacyConsentService.hasMadeChoiceAnalytics || !privacyConsentService.hasMadeChoiceCrashReports) {
  //   // Trigger navigation to your consent screen/dialog.
  //   // E.g., schedule a task to show it after the first frame:
  //   // WidgetsBinding.instance.addPostFrameCallback((_) {
  //   //   if (navigatorKey.currentContext != null && navigatorKey.currentContext!.mounted) {
  //   //      Navigator.of(navigatorKey.currentContext!).push(MaterialPageRoute(builder: (_) => YourConsentScreen()));
  //   //   } else {
  //   //      // Handle case where context isn't available, maybe retry or log.
  //   //   }
  //   // });
  //   print("TODO: Implement logic to show privacy consent screen if choices haven't been made.");
  // }

  // // Example conditional initialization of a service (e.g., Analytics)
  // // This logic might also live inside your AnalyticsService.init() or SentryLogger.init() methods,
  // // where they internally check consent before proceeding.
  // if (privacyConsentService.isAnalyticsConsentGranted) {
  //   // sl<AnalyticsService>().initialize(); // Or however your service is started/enabled
  //   print("Analytics Service would be initialized/enabled (consent granted).");
  // } else {
  //   print("Analytics Service NOT initialized/disabled (consent NOT granted or pending choice).");
  // }
  //
  // // Example conditional initialization for Sentry (or your SentryLogger)
  // if (privacyConsentService.isCrashReportConsentGranted) {
  //   // Actual Sentry.init or sl<LoggerService>().init() might check this internally.
  //   // If SentryLogger's init is called regardless (from core_services_module),
  //   // its internal methods (log, addBreadcrumb) should respect this consent.
  //   print("Crash Reporting (Sentry) would be initialized/enabled (consent granted).");
  // } else {
  //   print("Crash Reporting (Sentry) NOT initialized/disabled (consent NOT granted or pending choice).");
  // }
  // --- End Privacy Consent Service ---

  // runApp(const MyApp());
  // More setup here, like Bloc observers, etc.
   runApp(const MyApp()); // Temporary, replace with actual App widget
}
