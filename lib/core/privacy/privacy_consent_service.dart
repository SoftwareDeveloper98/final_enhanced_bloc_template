import 'package:shared_preferences/shared_preferences.dart'; // Placeholder, actual import needed

// Service to manage user consent for privacy-related features like
// analytics, crash reporting, and personalized content/ads.
class PrivacyConsentService {
  late SharedPreferences _prefs;

  static const String _keyAnalyticsConsent = 'privacy_consent_analytics';
  static const String _keyCrashReportConsent = 'privacy_consent_crash_report';
  // Add more keys for other consent types, e.g., personalization
  // static const String _keyPersonalizationConsent = 'privacy_consent_personalization';

  // Tracks if the user has made any choice for a particular consent.
  // This is useful to distinguish between "not yet chosen" and "explicitly denied".
  static const String _hasMadeChoiceAnalytics = 'privacy_choice_made_analytics';
  static const String _hasMadeChoiceCrashReports = 'privacy_choice_made_crash_reports';

  bool _isInitialized = false;

  // Initializes SharedPreferences. Must be called before using other methods.
  Future<void> init() async {
    if (_isInitialized) return;
    _prefs = await SharedPreferences.getInstance();
    _isInitialized = true;
    print("PrivacyConsentService Initialized.");
  }

  // --- Analytics Consent ---
  bool get isAnalyticsConsentGranted => _prefs.getBool(_keyAnalyticsConsent) ?? false;
  bool get hasMadeChoiceAnalytics => _prefs.getBool(_hasMadeChoiceAnalytics) ?? false;

  Future<void> setAnalyticsConsent(bool isGranted) async {
    await _prefs.setBool(_keyAnalyticsConsent, isGranted);
    await _prefs.setBool(_hasMadeChoiceAnalytics, true);
    print("Analytics consent set to: $isGranted");
    // TODO: If consent is granted, initialize analytics service.
    // If consent is revoked, disable analytics service / delete collected data if required by policy.
  }

  // --- Crash Reporting Consent ---
  bool get isCrashReportConsentGranted => _prefs.getBool(_keyCrashReportConsent) ?? false;
  bool get hasMadeChoiceCrashReports => _prefs.getBool(_hasMadeChoiceCrashReports) ?? false;

  Future<void> setCrashReportConsent(bool isGranted) async {
    await _prefs.setBool(_keyCrashReportConsent, isGranted);
    await _prefs.setBool(_hasMadeChoiceCrashReports, true);
    print("Crash report consent set to: $isGranted");
    // TODO: If consent is granted, initialize crash reporting service (e.g., Sentry).
    // If consent is revoked, ensure crash reports are not sent.
  }

  // --- General Utility ---

  /// Resets all consent choices and status.
  /// Useful for testing or if a user wants to "forget all settings".
  Future<void> resetAllConsents() async {
    await _prefs.remove(_keyAnalyticsConsent);
    await _prefs.remove(_hasMadeChoiceAnalytics);
    await _prefs.remove(_keyCrashReportConsent);
    await _prefs.remove(_hasMadeChoiceCrashReports);
    // Remove other consent keys
    print("All privacy consents have been reset.");
  }

  /// Checks if all essential consents have been addressed by the user.
  /// This might be used to gate certain app functionalities or prompt for pending choices.
  bool get hasUserMadeAllNecessaryChoices => hasMadeChoiceAnalytics && hasMadeChoiceCrashReports;

  // Example: Check if consent is required before enabling a feature.
  // void enableSomeFeatureIfConsented() {
  //   if (isAnalyticsConsentGranted) {
  //     // enable feature that uses analytics
  //   }
  // }
}

// Example Usage (typically after DI setup and service initialization):
//
// final consentService = sl<PrivacyConsentService>(); // from GetIt
// await consentService.init(); // Ensure it's initialized
//
// // Check if user needs to be prompted for analytics consent
// if (!consentService.hasMadeChoiceAnalytics) {
//   // Show consent dialog/screen for analytics
// }
//
// // Later, when user makes a choice on a settings screen:
// // await consentService.setAnalyticsConsent(true);
//
// // Conditional initialization of services:
// if (consentService.isAnalyticsConsentGranted) {
//   // Initialize analytics
// }
// if (consentService.isCrashReportConsentGranted) {
//   // Initialize crash reporting
// }
