import 'package:get_it/get_it.dart';

/// Global Service Locator instance.
///
/// This exports the `GetIt.instance` for convenient access throughout the app.
/// It's generally recommended to pass dependencies via constructors where possible,
/// but a service locator can be useful for accessing services in places where
/// constructor injection is difficult or for utility services.
///
/// Example usage:
/// ```
/// final networkService = sl<NetworkService>();
/// ```
final GetIt sl = GetIt.instance;
