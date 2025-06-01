import 'package:injectable/injectable.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

@module
abstract class InjectorModule {
  // Example of a simple injectable dependency (can be removed later)
  // @lazySingleton
  // String get appVersion => "1.0.0";

  @lazySingleton
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage();
}
