abstract class AnalyticsService {
  Future<void> init();
  void logEvent(String name, {Map<String, dynamic>? parameters});
}
