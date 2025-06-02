import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Placeholder, actual import needed

// Abstract class defining the contract for secure storage operations.
abstract class SecureStorageService {
  Future<void> write({required String key, required String value});
  Future<String?> read({required String key});
  Future<Map<String, String>> readAll();
  Future<void> delete({required String key});
  Future<void> deleteAll();
  Future<bool> containsKey({required String key});
}

// Implementation of SecureStorageService using flutter_secure_storage.
class FlutterSecureStorageService implements SecureStorageService {
  final FlutterSecureStorage _storage;

  // Options can be configured for Android and iOS for more specific behaviors.
  // For example, AndroidOptions(encryptedSharedPreferences: true) for newer Android versions.
  // final IOSOptions _iosOptions = const IOSOptions(accessibility: KeychainAccessibility.first_unlock);
  // final AndroidOptions _androidOptions = const AndroidOptions(encryptedSharedPreferences: true);

  FlutterSecureStorageService({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage(
          // aOptions: _androidOptions, // Example: pass android options
          // iOptions: _iosOptions,   // Example: pass iOS options
        );

  @override
  Future<void> write({required String key, required String value}) async {
    try {
      await _storage.write(
        key: key,
        value: value,
        // iOptions: _iosOptions,
        // aOptions: _androidOptions,
      );
    } catch (e) {
      // TODO: Log error with a proper logger
      print('Error writing to secure storage: $e');
      rethrow; // Or handle more gracefully
    }
  }

  @override
  Future<String?> read({required String key}) async {
    try {
      return await _storage.read(
        key: key,
        // iOptions: _iosOptions,
        // aOptions: _androidOptions,
      );
    } catch (e) {
      print('Error reading from secure storage: $e');
      return null; // Or rethrow
    }
  }

  @override
  Future<Map<String, String>> readAll() async {
    try {
      return await _storage.readAll(
        // iOptions: _iosOptions,
        // aOptions: _androidOptions,
      );
    } catch (e) {
      print('Error reading all from secure storage: $e');
      return {}; // Or rethrow
    }
  }

  @override
  Future<void> delete({required String key}) async {
    try {
      await _storage.delete(
        key: key,
        // iOptions: _iosOptions,
        // aOptions: _androidOptions,
      );
    } catch (e) {
      print('Error deleting from secure storage: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteAll() async {
    try {
      await _storage.deleteAll(
        // iOptions: _iosOptions,
        // aOptions: _androidOptions,
      );
    } catch (e) {
      print('Error deleting all from secure storage: $e');
      rethrow;
    }
  }

  @override
  Future<bool> containsKey({required String key}) async {
    try {
      return await _storage.containsKey(
        key: key,
        // iOptions: _iosOptions,
        // aOptions: _androidOptions,
      );
    } catch (e) {
      print('Error checking key in secure storage: $e');
      return false; // Or rethrow
    }
  }
}

// Example of how to use it:
// final secureStorage = FlutterSecureStorageService();
// await secureStorage.write(key: 'auth_token', value: 'secret_token_here');
// String? token = await secureStorage.read(key: 'auth_token');
// print('Token: $token');
// await secureStorage.delete(key: 'auth_token');
