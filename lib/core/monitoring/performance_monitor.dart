import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:clean_bloc_template/core/config/build_config.dart';

/// Performance monitoring service for tracking app performance metrics
class PerformanceMonitor {
  /// Private constructor to enforce singleton pattern
  PerformanceMonitor._();

  /// Singleton instance
  static final PerformanceMonitor _instance = PerformanceMonitor._();

  /// Get the singleton instance
  static PerformanceMonitor get instance => _instance;

  /// Logger instance for performance logs
  late final Logger _logger;
  
  /// Whether performance monitoring is enabled
  bool _isEnabled = false;
  
  /// Map to store operation start times
  final Map<String, DateTime> _operationStartTimes = {};
  
  /// Map to store frame build times
  final List<Duration> _frameBuildTimes = [];
  
  /// Initialize the performance monitor
  void initialize() {
    _isEnabled = BuildConfig.instance.enablePerformanceMonitoring;
    
    _logger = Logger(
      printer: PrettyPrinter(
        methodCount: 0,
        errorMethodCount: 5,
        lineLength: 50,
        colors: true,
        printEmojis: true,
        printTime: true,
      ),
      level: _isEnabled ? Level.info : Level.nothing,
    );
    
    if (_isEnabled) {
      _setupFrameCallback();
      _logger.i('Performance monitoring initialized');
    }
  }
  
  /// Set up frame callback to monitor UI performance
  void _setupFrameCallback() {
    WidgetsBinding.instance.addTimingsCallback((List<FrameTiming> timings) {
      if (!_isEnabled) return;
      
      for (final timing in timings) {
        final buildDuration = Duration(microseconds: timing.buildDuration);
        final rasterDuration = Duration(microseconds: timing.rasterDuration);
        final totalDuration = buildDuration + rasterDuration;
        
        _frameBuildTimes.add(totalDuration);
        
        // Log slow frames (> 16ms, which is below 60fps)
        if (totalDuration.inMilliseconds > 16) {
          _logger.w('Slow frame detected: ${totalDuration.inMilliseconds}ms '
              '(build: ${buildDuration.inMilliseconds}ms, '
              'raster: ${rasterDuration.inMilliseconds}ms)');
        }
      }
    });
  }
  
  /// Start timing an operation
  void startOperation(String operationName) {
    if (!_isEnabled) return;
    _operationStartTimes[operationName] = DateTime.now();
  }
  
  /// End timing an operation and log the duration
  void endOperation(String operationName) {
    if (!_isEnabled) return;
    
    final startTime = _operationStartTimes[operationName];
    if (startTime == null) {
      _logger.w('Operation "$operationName" was never started');
      return;
    }
    
    final duration = DateTime.now().difference(startTime);
    _logger.i('Operation "$operationName" completed in ${duration.inMilliseconds}ms');
    _operationStartTimes.remove(operationName);
  }
  
  /// Track a custom performance metric
  void trackMetric(String metricName, dynamic value) {
    if (!_isEnabled) return;
    _logger.i('Metric "$metricName": $value');
    
    // In a real implementation, you might send this to a backend service
    // like Firebase Performance Monitoring, New Relic, etc.
  }
  
  /// Get average frame build time over the last N frames
  Duration getAverageFrameTime([int frameCount = 60]) {
    if (_frameBuildTimes.isEmpty) return Duration.zero;
    
    final frames = _frameBuildTimes.length < frameCount 
        ? _frameBuildTimes 
        : _frameBuildTimes.sublist(_frameBuildTimes.length - frameCount);
    
    final totalMicroseconds = frames.fold<int>(
      0, (sum, duration) => sum + duration.inMicroseconds);
    
    return Duration(microseconds: totalMicroseconds ~/ frames.length);
  }
  
  /// Get current FPS based on recent frame times
  double getCurrentFps() {
    final avgFrameTime = getAverageFrameTime();
    if (avgFrameTime.inMicroseconds == 0) return 60.0; // Default to 60fps
    
    return 1000000 / avgFrameTime.inMicroseconds; // Convert microseconds to fps
  }
}

/// Widget that monitors build performance of its child
class PerformanceMonitorWidget extends StatefulWidget {
  /// Child widget to monitor
  final Widget child;
  
  /// Name of the widget being monitored
  final String widgetName;
  
  /// Constructor
  const PerformanceMonitorWidget({
    Key? key,
    required this.child,
    required this.widgetName,
  }) : super(key: key);

  @override
  State<PerformanceMonitorWidget> createState() => _PerformanceMonitorWidgetState();
}

class _PerformanceMonitorWidgetState extends State<PerformanceMonitorWidget> {
  @override
  void initState() {
    super.initState();
    PerformanceMonitor.instance.startOperation('build_${widget.widgetName}');
  }
  
  @override
  void dispose() {
    PerformanceMonitor.instance.endOperation('build_${widget.widgetName}');
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
