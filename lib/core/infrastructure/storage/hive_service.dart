import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart'; // Added missing import
import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';

@module
abstract class StorageModule {
  @preResolve // Ensure Hive is initialized before it's used
  @singleton
  Future<HiveInterface> hive() async {
    // Get application documents directory
    final appDocumentDir = await getApplicationDocumentsDirectory();
    // Initialize Hive in the app's directory
    Hive.init(appDocumentDir.path);
    // TODO: Register Hive adapters here if needed
    // Hive.registerAdapter(YourModelAdapter());
    return Hive;
  }

  // Example of opening a box. You might want more specific boxes.
  @preResolve
  @lazySingleton
  Future<Box<dynamic>> settingsBox(HiveInterface hive) async {
    return await hive.openBox("settings");
  }

  // You can add more boxes here as needed
  // @preResolve
  // @lazySingleton
  // Future<Box<User>> userBox(HiveInterface hive) async {
  //   return await hive.openBox<User>("userBox");
  // }
}

// Optional: A simple wrapper/manager for common Hive operations
@lazySingleton
class CacheManager {
  final Box<dynamic> _settingsBox;

  // Use @Named to specify which box to inject if multiple are registered
  CacheManager(@Named("settingsBox") this._settingsBox);

  Future<void> saveSetting(String key, dynamic value) async {
    await _settingsBox.put(key, value);
  }

  dynamic getSetting(String key, {dynamic defaultValue}) {
    return _settingsBox.get(key, defaultValue: defaultValue);
  }

  Future<void> deleteSetting(String key) async {
    await _settingsBox.delete(key);
  }

  // Add more specific methods for typed boxes if needed
}

