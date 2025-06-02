import 'package:get_it/get_it.dart';
// Import actual services here as they are created
// import 'package:my_app/core/network/network_service.dart';
// import 'package:my_app/core/storage/storage_service.dart';
import 'package:my_app/core/observability/analytics/analytics_service.dart';
import 'package:my_app/core/observability/analytics/providers/firebase_analytics_provider.dart';
import 'package:my_app/core/observability/analytics/providers/console_analytics_provider.dart';
import 'package:my_app/core/observability/logging/logger_service.dart';
import 'package:my_app/core/observability/logging/providers/console_logger.dart';
import 'package:my_app/core/observability/logging/providers/sentry_logger.dart';
import 'package:my_app/core/observability/tracing/trace_context_service.dart';
import 'package:my_app/core/observability/monitoring/ui_performance_monitor.dart';

// Function to configure core services
void configureCoreServices(GetIt sl, String environment) {
  // LoggerService - Environment-specific registration
  if (environment == 'prod' || environment == 'staging') {
    sl.registerLazySingleton<LoggerService>(() => SentryLogger());
  } else { // 'dev', 'test', or any other environment
    sl.registerLazySingleton<LoggerService>(() => ConsoleLogger());
  }
  // Eagerly initialize LoggerService
  sl.get<LoggerService>().init();

  // NetworkService
  // sl.registerLazySingleton<NetworkService>(() => NetworkServiceImpl());

  // StorageService
  // sl.registerLazySingleton<StorageService>(() => StorageServiceImpl()); // For non-secure storage like SharedPreferences wrapper

  // SecureStorageService
  // sl.registerLazySingleton<SecureStorageService>(() => FlutterSecureStorageService());
  // No async init method defined in SecureStorageService, it's ready upon instantiation.

  // PrivacyConsentService - requires async initialization
  // sl.registerSingletonAsync<PrivacyConsentService>(() async {
  //   final service = PrivacyConsentService();
  //   await service.init(); // Initializes SharedPreferences
  //   return service;
  // });
  // Ensure this is awaited during app initialization using `await sl.isReady<PrivacyConsentService>()`
  // or by making `configureDependencies` in `app_injector.dart` return Future and awaiting it.

  // AnalyticsService - Platform-specific registration
  if (environment == 'prod') {
    sl.registerLazySingleton<AnalyticsService>(() => FirebaseAnalyticsProvider());
  } else {
    sl.registerLazySingleton<AnalyticsService>(() => ConsoleAnalyticsProvider());
  }
  // Eagerly initialize the AnalyticsService after registration
  // In a real app, you might call init during app startup or when the service is first resolved.
  sl.get<AnalyticsService>().init();

  // TraceContextService
  sl.registerLazySingleton<TraceContextService>(() => LoggingTraceContextService(logger: sl<LoggerService>()));
  // No async init for LoggingTraceContextService, but if it had one:
  // sl.get<TraceContextService>().init();

  // UiPerformanceMonitor
  sl.registerLazySingleton<UiPerformanceMonitor>(() => UiPerformanceMonitor(logger: sl<LoggerService>()));
  // No async init for UiPerformanceMonitor as defined, but if it had one:
  // sl.get<UiPerformanceMonitor>().init();


  // Other core services like CrashReportingService, etc. could be registered here.
  // e.g. sl.registerLazySingleton<CrashReportingService>(() => CrashReportingServiceImpl(sl()));

  print("Core services configured for environment: $environment. Logger: ${sl<LoggerService>().runtimeType}");
}
