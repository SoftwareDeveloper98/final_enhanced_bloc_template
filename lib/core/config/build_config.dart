import 'package:flutter/foundation.dart';

/// Enum representing different environment types for the application
enum Environment {
  /// Development environment for testing and debugging
  dev,
  
  /// Staging environment for pre-production testing
  staging,
  
  /// Production environment for release builds
  prod,
}

/// Configuration class for managing build-specific settings
class BuildConfig {
  /// The current environment (dev, staging, prod)
  final Environment environment;
  
  /// Base URL for API calls
  final String apiBaseUrl;
  
  /// Whether to enable detailed logging
  final bool enableLogging;
  
  /// Whether to enable crash reporting
  final bool enableCrashReporting;
  
  /// Whether to enable performance monitoring
  final bool enablePerformanceMonitoring;
  
  /// API key for external services
  final String apiKey;

  /// Private constructor to enforce singleton pattern
  const BuildConfig._({
    required this.environment,
    required this.apiBaseUrl,
    required this.enableLogging,
    required this.enableCrashReporting,
    required this.enablePerformanceMonitoring,
    required this.apiKey,
  });

  /// Singleton instance of BuildConfig
  static late BuildConfig _instance;

  /// Initialize the BuildConfig with environment-specific values
  static void init({
    required Environment environment,
    required String apiBaseUrl,
    required String apiKey,
    bool? enableLogging,
    bool? enableCrashReporting,
    bool? enablePerformanceMonitoring,
  }) {
    _instance = BuildConfig._(
      environment: environment,
      apiBaseUrl: apiBaseUrl,
      apiKey: apiKey,
      enableLogging: enableLogging ?? environment != Environment.prod,
      enableCrashReporting: enableCrashReporting ?? environment == Environment.prod,
      enablePerformanceMonitoring: enablePerformanceMonitoring ?? environment == Environment.prod,
    );
  }

  /// Get the current BuildConfig instance
  static BuildConfig get instance {
    assert(_instance != null, 'BuildConfig has not been initialized. Call BuildConfig.init() first.');
    return _instance;
  }

  /// Check if the current environment is development
  bool get isDev => environment == Environment.dev;

  /// Check if the current environment is staging
  bool get isStaging => environment == Environment.staging;

  /// Check if the current environment is production
  bool get isProd => environment == Environment.prod;

  /// Get environment name as a string
  String get environmentName => environment.name;

  @override
  String toString() {
    return '''
    BuildConfig(
      environment: $environment,
      apiBaseUrl: $apiBaseUrl,
      enableLogging: $enableLogging,
      enableCrashReporting: $enableCrashReporting,
      enablePerformanceMonitoring: $enablePerformanceMonitoring,
      apiKey: ${kReleaseMode ? '***' : apiKey}
    )
    ''';
  }
}
