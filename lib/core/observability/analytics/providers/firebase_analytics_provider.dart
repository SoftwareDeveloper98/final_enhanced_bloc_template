import 'package:my_app/core/observability/analytics/analytics_service.dart';
// import 'package:firebase_analytics/firebase_analytics.dart'; // Add to pubspec if not there

class FirebaseAnalyticsProvider implements AnalyticsService {
  // final FirebaseAnalytics _firebaseAnalytics = FirebaseAnalytics.instance;

  @override
  Future<void> init() async {
    // Initialization logic if needed, e.g., check for consent.
    // await _firebaseAnalytics.setAnalyticsCollectionEnabled(true);
    print("FirebaseAnalyticsProvider initialized");
  }

  @override
  void logEvent(String name, {Map<String, dynamic>? parameters}) {
    // _firebaseAnalytics.logEvent(name: name, parameters: parameters);
    print('Firebase Event: $name, Parameters: $parameters');
  }
}
