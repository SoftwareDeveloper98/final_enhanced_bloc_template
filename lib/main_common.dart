import 'package:flutter/foundation.dart'; // Required for kIsWeb
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart'; // Import HydratedBloc
import 'package:path_provider/path_provider.dart'; // Import path_provider

import 'app/di/injector.dart';
import 'app/view/app.dart';
// No need to import HiveService directly if DI handles initialization

// Define environment constants
abstract class AppEnvironment {
  static const String dev = 'dev';
  static const String prod = 'prod';
  // Add other environments like staging if needed
}

Future<void> mainCommon(String environment) async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // TODO: Add robust error handling for initialization (e.g., try-catch)
  // TODO: Setup logging framework here

  // Initialize HydratedBloc storage
  HydratedBloc.storage = await HydratedStorage.build(
    // Use path_provider to get a suitable directory
    // kIsWeb is used to determine if running on web, where path_provider might not be needed/supported directly for default storage
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getApplicationDocumentsDirectory(),
  );

  // Initialize dependency injection
  // Note: Hive initialization is handled within the StorageModule via @preResolve
  await configureDependencies(environment: environment);

  // TODO: Load environment-specific configurations here

  // Run the app
  runApp(const App());
}

