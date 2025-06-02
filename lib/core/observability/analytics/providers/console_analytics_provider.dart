import 'package:my_app/core/observability/analytics/analytics_service.dart';

class ConsoleAnalyticsProvider implements AnalyticsService {
  @override
  Future<void> init() async {
    // No specific initialization needed for console logging.
    print("ConsoleAnalyticsProvider initialized");
  }

  @override
  void logEvent(String name, {Map<String, dynamic>? parameters}) {
    print('Console Event: $name, Parameters: $parameters');
  }
}
