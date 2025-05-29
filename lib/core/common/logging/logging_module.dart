import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

// Import environment constants (still useful for reference, but use literals in annotations for now)
// import '../../main_common.dart'; 

@module
abstract class LoggingModule {
  // Logger depends on AppLogFilter, which will be resolved based on the environment
  @lazySingleton
  Logger logger(AppLogFilter logFilter) {
    return Logger(
      printer: PrettyPrinter(
        methodCount: 1, // number of method calls to be displayed
        errorMethodCount: 5, // number of method calls if stacktrace is provided
        lineLength: 100, // width of the output
        colors: true, // Colorful log messages
        printEmojis: true, // Print an emoji for each log message
        printTime: true, // Should each log print contain a timestamp
      ),
      filter: logFilter, // Use the environment-specific filter provided by DI
    );
  }
}

// Abstract class for log filters (remains the same)
abstract class AppLogFilter extends LogFilter {}

// Development filter: logs everything
// Register this implementation for the 'dev' environment using a literal string
@Injectable(as: AppLogFilter, env: ['dev'])
class DevLogFilter extends AppLogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return true; // Log everything in development
  }
}

// Production filter: logs only warnings and errors
// Register this implementation for the 'prod' environment using a literal string
@Injectable(as: AppLogFilter, env: ['prod'])
class ProdLogFilter extends AppLogFilter {
  @override
  bool shouldLog(LogEvent event) {
    // In production, log only warnings, errors, and fatal errors
    return event.level.index >= Level.warning.index;
  }
}

// Staging filter (example)
// @Injectable(as: AppLogFilter, env: ['staging']) // Use literal string
// class StagingLogFilter extends AppLogFilter {
//   @override
//   bool shouldLog(LogEvent event) {
//     // Example: Log info and above in staging
//     return event.level.index >= Level.info.index;
//   }
// }

