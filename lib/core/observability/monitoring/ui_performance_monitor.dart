import 'dart:async';
import 'package:flutter/scheduler.dart';
import 'package:my_app/core/observability/logging/logger_service.dart';

class UiPerformanceMonitor {
  final LoggerService logger;
  Timer? _jankMonitorTimer;
  final int _jankThresholdMs = 100; // Report if a frame takes longer than 100ms (e.g. > 6 FPS for that frame)
  final Duration _monitorInterval = const Duration(seconds: 5);

  // For tracking long tasks on the main isolate
  static const int _longTaskThresholdMs = 50; // W3C definition of a long task

  UiPerformanceMonitor({required this.logger});

  void startMonitoring() {
    logger.info("UI Performance Monitor starting...");

    // 1. Frame Callback for Jank Detection (Simplified)
    // This is a very basic way. Real apps might use `addTimingsCallback`.
    // However, `addTimingsCallback` reports all frames, which can be verbose.
    // This example focuses on periodic checks for jank.
    _jankMonitorTimer = Timer.periodic(_monitorInterval, (_) {
      // This check is too simplistic for real jank detection.
      // A real implementation would need to hook into frame timings more directly.
      // For this example, we'll simulate a check.
      // logger.debug("Periodic jank check (conceptual)");
    });

    // Using Ticker for a conceptual jank detection (more frequent but still basic)
    final ticker = Ticker(_onTick);
    ticker.start();
    // ticker.dispose(); // Needs to be called when monitor is stopped

    // 2. Monitoring for Long Tasks (Conceptual - Dart single-threaded nature)
    // In Dart's single-threaded model, a "long task" on the main isolate that blocks
    // UI rendering is essentially a frame that takes too long.
    // More advanced native monitoring (e.g. Sentry native integration) can detect ANRs.
    // We can log when frame callbacks take too long.

    logger.info("UI Performance Monitor started. Jank threshold: ${_jankThresholdMs}ms, Long Task Threshold: ${_longTaskThresholdMs}ms");
  }

  DateTime? _lastTickTime;
  void _onTick(Duration elapsed) {
    final now = DateTime.now();
    if (_lastTickTime != null) {
      final delta = now.difference(_lastTickTime!).inMilliseconds;
      if (delta > _jankThresholdMs) { // Should be based on frame budget (e.g. 16ms for 60FPS)
        logger.warning(
          "Potential Jank Detected: Frame processing time was ${delta}ms (exceeded threshold of $_jankThresholdMs ms)",
          context: {'durationMs': delta, 'thresholdMs': _jankThresholdMs}
        );
      }
    }
    _lastTickTime = now;
  }


  void logUiEvent(String eventName, {Map<String, dynamic>? details}) {
    logger.info("UI Event: $eventName", context: details);
    // In a real system, this might start a UI performance trace/span
  }

  void reportScreenLoadTime(String screenName, Duration loadTime, {Map<String, dynamic>? metadata}) {
    if (loadTime.inMilliseconds > 500) { // Example threshold
      logger.warning(
        "Slow Screen Load: $screenName took ${loadTime.inMilliseconds}ms",
        context: {
          'screenName': screenName,
          'loadTimeMs': loadTime.inMilliseconds,
          if (metadata != null) ...metadata,
        },
      );
    } else {
      logger.info(
        "Screen Load: $screenName loaded in ${loadTime.inMilliseconds}ms",
        context: {
          'screenName': screenName,
          'loadTimeMs': loadTime.inMilliseconds,
          if (metadata != null) ...metadata,
        },
      );
    }
  }

  // Example method to be called by FlutterError.onError
  void reportFlutterError(dynamic exception, StackTrace stackTrace) {
    logger.error("FlutterError caught by UIPerformanceMonitor", error: exception, stackTrace: stackTrace);
    // This could also initiate specific UI error reporting logic
  }


  void dispose() {
    logger.info("Disposing UI Performance Monitor.");
    _jankMonitorTimer?.cancel();
    // If Ticker was used and stored: _ticker.dispose();
    _lastTickTime = null;
  }
}
