import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'service_locator.config.dart'; // Will be generated

final getIt = GetIt.instance;

@injectableInit
Future<void> configureDependencies({String? environment}) async {
  await $initGetIt(getIt, environment: environment);
}

// Define environment constants
abstract class Env {
  static const String dev = 'dev';
  static const String prod = 'prod';
  static const String staging = 'staging';
}
