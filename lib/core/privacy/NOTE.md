# Privacy Consent Service Notes

This directory contains the `PrivacyConsentService` responsible for managing user consent for various privacy-related features such as analytics, crash reporting, and potentially personalized content or advertising.

## Dependencies

To use the `PrivacyConsentService` as implemented (which uses `shared_preferences` for persistence), you need to add the `shared_preferences` package to your `pubspec.yaml` file:

```yaml
dependencies:
  flutter:
    sdk: flutter
  # ... other dependencies ...

  shared_preferences: ^2.2.2 # Or the latest version
```

After adding the dependency, run `flutter pub get`.

## Functionality
-   **Persistence:** User consent choices are persisted locally on the device using `SharedPreferences`.
-   **Granular Consent:** Allows managing consent for different categories (e.g., analytics, crash reports) independently.
-   **Choice Tracking:** It not only stores the grant status (true/false) but also whether the user has made a choice for a specific category. This is important to differentiate between "not yet asked" and "explicitly denied".
-   **Initialization:** The service requires asynchronous initialization (`await service.init()`) to load `SharedPreferences` before it can be used. This should be handled during app startup.

## Integration

1.  **Dependency Injection (DI):**
    *   Register `PrivacyConsentService` as a singleton in your DI setup (e.g., in `lib/core/di/core_services_module.dart`).
    *   Since its `init()` method is async, use `registerSingletonAsync` if your DI provider supports it (like GetIt):
        ```dart
        // In core_services_module.dart
        // sl.registerSingletonAsync<PrivacyConsentService>(() async {
        //   final service = PrivacyConsentService();
        //   await service.init();
        //   return service;
        // });
        ```
    *   Ensure this async registration is completed during app startup, for example, by calling `await sl.allReady()` or `await sl.isReady<PrivacyConsentService>()` in your `main_common.dart` or equivalent.

2.  **Initial Consent Flow:**
    *   On the first app launch (or when `hasMadeChoiceAnalytics`, `hasMadeChoiceCrashReports`, etc., are false), your application should present a UI to the user to obtain their consent choices. This could be a dedicated consent screen, a dialog, or part of an onboarding flow.
    *   This UI should clearly explain what each consent option means and link to your privacy policy.
    *   The `PrivacySettingsScreen` (`lib/features/settings/presentation/ui/screens/privacy_settings_screen.dart`) provides an example of how users can manage these settings later, but the initial prompt is crucial.
    *   **Important:** Triggering this UI might require careful handling of `BuildContext` availability if done very early in `main_common.dart`. Using `WidgetsBinding.instance.addPostFrameCallback` can help schedule UI actions after the first frame.

3.  **Conditional Service Initialization/Operation:**
    *   Other services that depend on user consent (e.g., `AnalyticsService`, `LoggerService` if it sends data to Sentry) should check the consent status from `PrivacyConsentService` before initializing or performing actions.
    *   Example in `main_common.dart` or within the services themselves:
        ```dart
        // final privacyConsentService = sl<PrivacyConsentService>();
        // if (privacyConsentService.isAnalyticsConsentGranted) {
        //   // Initialize or enable analytics collection
        // }
        // if (privacyConsentService.isCrashReportConsentGranted) {
        //   // Initialize or enable crash reporting
        // }
        ```
    *   For services like Sentry, this might mean only initializing Sentry if consent is granted, or if Sentry is always initialized, its `beforeSend` callback could be used to drop events if consent is not given.

4.  **Settings Screen:**
    *   Provide a screen (like the example `PrivacySettingsScreen`) where users can review and change their consent choices at any time.
    *   This screen should read the current consent status from `PrivacyConsentService` and update it when the user changes settings.

## Considerations
-   **Legal Compliance (GDPR, CCPA, etc.):** Ensure your consent mechanisms and data handling practices comply with relevant privacy regulations in the regions where your app is used. This includes clear language, granular choices, easy withdrawal of consent, and data access/deletion requests if applicable.
-   **User Experience:** Make the consent process clear, transparent, and user-friendly. Avoid dark patterns.
-   **Default State:** Decide on the default behavior if a user hasn't made a choice (usually, this means consent is NOT granted).
-   **Revoking Consent:** When consent is revoked for a service, ensure that data collection stops. Depending on regulations and your policies, you might also need to delete previously collected data. This service provides the mechanism to store consent; data deletion logic would be part of the respective services (e.g., Analytics service).

This `PrivacyConsentService` provides a foundational piece for managing user privacy preferences. It needs to be complemented by appropriate UI elements and careful integration into the lifecycle of dependent services.
