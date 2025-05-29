import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injector.config.dart'; // Generated file

final getIt = GetIt.instance;

// Define environment constants matching main_common.dart
// abstract class AppEnvironment {
//   static const String dev = 'dev';
//   static const String prod = 'prod';
//   // Add staging if needed
// }

@InjectableInit(
  initializerName: r'$initGetIt', // default = $initGetIt
  preferRelativeImports: true, // default = true
  asExtension: false, // default = false, using a function call
  // generateForDir: ['lib'], // Optional: specify directories to scan. Default scans lib/
)
Future<void> configureDependencies({required String environment}) async {
  // Pass the environment string to the generated initializer
  // Ensure the environment string matches one of the injectable environment tags (e.g., @dev, @prod)
  // You might need to define these environment tags in your injectable modules or classes.
  print('Configuring dependencies for environment: $environment');
  await $initGetIt(getIt, environment: environment);

  // Feature Module Dependency Registration:
  // By default, @InjectableInit scans the entire 'lib' directory.
  // Therefore, classes annotated with @injectable, @lazySingleton, etc.,
  // within feature directories (e.g., lib/features/your_feature/...) will be
  // automatically discovered and registered by build_runner.
  //
  // If a feature requires more complex setup or module-level configuration,
  // you can create a dedicated @module class within the feature directory.
  // Example (in lib/features/your_feature/di/feature_module.dart):
  //
  // @module
  // abstract class YourFeatureModule {
  //   @lazySingleton
  //   YourFeatureSpecificService get service => YourFeatureSpecificServiceImpl();
  //
  //   // Register dependencies specific to this feature
  // }
  //
  // This module will also be automatically picked up by the build runner.
}

// Example of how to define environment tags for injectable:
// Use @dev, @prod, @test annotations on your modules or classes.
// Example Module (in lib/core/infrastructure/network/dio_client.dart):
// @module
// abstract class NetworkModule {
//   @prod
//   @Named('BaseUrl')
//   String get prodBaseUrl => 'https://api.prod.example.com';
//
//   @dev
//   @Named('BaseUrl')
//   String get devBaseUrl => 'https://api.dev.example.com';
//
//   @lazySingleton
//   Dio dio(@Named('BaseUrl') String baseUrl) { ... }
// }

// Example Class:
// @Injectable(as: SomeService, env: [Environment.dev])
// class DevSomeService implements SomeService { ... }
//
// @Injectable(as: SomeService, env: [Environment.prod])
// class ProdSomeService implements SomeService { ... }

