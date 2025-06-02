import 'package:get_it/get_it.dart';
import 'package:my_app/core/di/core_services_module.dart';
// Import feature modules here as they are created
// import 'package:my_app/features/auth/src/di/auth_module.dart';
// import 'package:my_app/features/home/src/di/home_module.dart';
// ... other feature modules

// Service locator instance
final sl = GetIt.instance;

/// Configures all dependencies for the application.
///
/// This function initializes the service locator and registers modules
/// from different layers (core, features).
///
/// [environment] can be used to register different dependencies
/// for different build environments (e.g., 'dev', 'staging', 'prod').
Future<void> configureDependencies(String environment) async {
  // Initialize GetIt instance
  // No need to explicitly initialize `sl` as GetIt.instance does this.

  // 1. Configure Core Services
  // This function will register cross-cutting concerns and core utilities.
  configureCoreServices(sl, environment);

  // 2. Configure Feature-Specific Dependencies
  // Each feature should have its own module to configure its specific dependencies
  // such as BLoCs/Cubits, UseCases, Repositories, and DataSources.

  // Example: Authentication Feature
  // configureAuthDependencies(sl); // Assuming AuthFeatureModule.configure(sl) or similar

  // Example: Home Feature
  // configureHomeDependencies(sl); // Assuming HomeFeatureModule.configure(sl) or similar

  // Example: Product Feature
  // ProductFeatureModule.configure(sl);

  // ... Register other feature modules

  print("All dependencies configured for environment: $environment");

  // For services that require asynchronous initialization and are not handled
  // within their respective registration modules (like AnalyticsService was),
  // you might await them here or ensure they are initialized before the app runs.
  // e.g., await sl.get<SomeAsyncService>().init();
}
