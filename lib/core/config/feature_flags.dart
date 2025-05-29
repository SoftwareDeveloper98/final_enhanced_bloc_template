import 'package:flutter/material.dart';
import 'package:clean_bloc_template/core/config/build_config.dart';

/// Feature flag service to manage feature availability across different environments
class FeatureFlags {
  /// Private constructor to enforce singleton pattern
  FeatureFlags._();

  /// Singleton instance
  static final FeatureFlags _instance = FeatureFlags._();

  /// Get the singleton instance
  static FeatureFlags get instance => _instance;

  /// Map of feature flags and their values
  final Map<String, bool> _flags = {};

  /// Initialize feature flags based on environment and remote configuration
  void initialize() {
    // Default flags based on environment
    final environment = BuildConfig.instance.environment;
    
    // Core features - always enabled
    _flags['core_feature'] = true;
    
    // Environment-specific features
    switch (environment) {
      case Environment.dev:
        _setDevFlags();
        break;
      case Environment.staging:
        _setStagingFlags();
        break;
      case Environment.prod:
        _setProdFlags();
        break;
    }
    
    debugPrint('Feature flags initialized for ${environment.name} environment: $_flags');
  }
  
  /// Set development environment flags
  void _setDevFlags() {
    _flags['experimental_ui'] = true;
    _flags['debug_tools'] = true;
    _flags['analytics'] = false;
    _flags['premium_features'] = true;
    _flags['dark_mode'] = true;
    _flags['push_notifications'] = true;
  }
  
  /// Set staging environment flags
  void _setStagingFlags() {
    _flags['experimental_ui'] = true;
    _flags['debug_tools'] = true;
    _flags['analytics'] = true;
    _flags['premium_features'] = true;
    _flags['dark_mode'] = true;
    _flags['push_notifications'] = true;
  }
  
  /// Set production environment flags
  void _setProdFlags() {
    _flags['experimental_ui'] = false;
    _flags['debug_tools'] = false;
    _flags['analytics'] = true;
    _flags['premium_features'] = true;
    _flags['dark_mode'] = true;
    _flags['push_notifications'] = true;
  }
  
  /// Update flags from remote configuration
  Future<void> updateFromRemote(Map<String, bool> remoteFlags) async {
    _flags.addAll(remoteFlags);
    debugPrint('Feature flags updated from remote: $_flags');
  }
  
  /// Check if a feature is enabled
  bool isEnabled(String featureKey) {
    final isEnabled = _flags[featureKey] ?? false;
    return isEnabled;
  }
  
  /// Get all feature flags
  Map<String, bool> get allFlags => Map.unmodifiable(_flags);
}

/// Extension on BuildContext to easily access feature flags
extension FeatureFlagsExtension on BuildContext {
  /// Check if a feature is enabled
  bool isFeatureEnabled(String featureKey) {
    return FeatureFlags.instance.isEnabled(featureKey);
  }
}
