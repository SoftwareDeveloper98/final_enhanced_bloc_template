# Secure Storage Service Notes

This directory contains the `SecureStorageService` abstraction and its implementation (`FlutterSecureStorageService`) for securely storing sensitive data like authentication tokens, API keys, or user preferences that require encryption at rest.

## Dependencies

To use the `FlutterSecureStorageService`, you need to add the `flutter_secure_storage` package to your `pubspec.yaml` file:

```yaml
dependencies:
  flutter:
    sdk: flutter
  # ... other dependencies ...

  flutter_secure_storage: ^9.0.0 # Or the latest version
```

After adding the dependency, run `flutter pub get`.

## Platform Configuration

The `flutter_secure_storage` package uses platform-specific mechanisms for secure storage:
-   **iOS:** Uses Keychain services.
-   **Android:** Uses EncryptedSharedPreferences (recommended for API 23+) or Keystore.

### iOS Specifics
-   **Keychain Sharing (Optional):** If you need to share data between multiple apps from the same developer, you might need to enable Keychain Sharing capability in Xcode.
-   **`Info.plist` (Face ID/Touch ID Usage Description):** If you use biometric protection for keychain items (not directly configured by default in `FlutterSecureStorageService` but possible with `IOSOptions`), you might need to add usage descriptions like `NSFaceIDUsageDescription` to your `Info.plist`. For default usage, this is not typically required.
-   **Accessibility:** `IOSOptions` allows specifying `accessibility` (e.g., `KeychainAccessibility.first_unlock`). The default is usually `after_first_unlock`.

### Android Specifics
-   **`encryptedSharedPreferences`:** `AndroidOptions(encryptedSharedPreferences: true)` uses AndroidX Security's EncryptedSharedPreferences, which is generally preferred for API 23+. This handles key management and encryption automatically.
-   **Keystore:** For older APIs or if `encryptedSharedPreferences` is false, it falls back to using the Android Keystore system for generating/storing encryption keys.
-   **ProGuard/R8:** If you are using ProGuard or R8 for code shrinking and obfuscation, ensure that rules are in place to keep necessary classes for `flutter_secure_storage` and AndroidX Security if you use `encryptedSharedPreferences`. Usually, this is handled by default rules, but it's good to be aware of.
-   **`minSdkVersion`:** Ensure your `android/app/build.gradle` has a `minSdkVersion` that is compatible with the features you intend to use (e.g., API 23 for EncryptedSharedPreferences).

## Usage
The `SecureStorageService` is typically registered as a singleton in your dependency injection setup (e.g., in `lib/core/di/core_services_module.dart`).

```dart
// Example registration (ensure FlutterSecureStorageService is imported)
// sl.registerLazySingleton<SecureStorageService>(() => FlutterSecureStorageService());

// Example usage in another service or repository:
// class AuthRepository {
//   final SecureStorageService _secureStorage;
//   AuthRepository(this._secureStorage);

//   Future<void> persistToken(String token) async {
//     await _secureStorage.write(key: 'auth_token', value: token);
//   }

//   Future<String?> getToken() async {
//     return await _secureStorage.read(key: 'auth_token');
//   }
// }
```

## Security Considerations
-   **Rooted/Jailbroken Devices:** While `flutter_secure_storage` uses platform secure elements, data stored by it can potentially be accessed on compromised (rooted/jailbroken) devices. For extremely sensitive data, consider additional layers of app-level security or server-side checks.
-   **Backup:** Data stored in Keychain on iOS might be backed up to iCloud unless configured otherwise (e.g., using `KeychainAccessibility.first_unlock_this_device_only`). EncryptedSharedPreferences on Android are typically part of app data backups if Auto Backup is enabled. Be mindful of this if storing data that should not leave the device.
-   **No Silver Bullet:** Secure storage helps protect data at rest on the device, but it's part of a larger security strategy that includes secure network communication (SSL/TLS with pinning), code obfuscation, and other measures.
-   **Key Rotation:** The underlying platform mechanisms handle cryptographic key management. `flutter_secure_storage` itself doesn't expose direct key rotation APIs.

This service provides a crucial layer for protecting sensitive information within your Flutter application. Always refer to the latest `flutter_secure_storage` documentation for detailed configuration options and best practices.
