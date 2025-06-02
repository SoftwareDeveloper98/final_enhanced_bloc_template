// Defines the contract for logging services and log levels.

enum LogLevel {
  debug, // Detailed information, typically of interest only when diagnosing problems.
  info, // Confirmation that things are working as expected.
  warning, // An indication that something unexpected happened, or indicative of some problem in the near future.
  error, // Due to a more serious problem, the software has not been able to perform some function.
  fatal, // A severe error event that will presumably lead the application to abort.
}

abstract class LoggerService {
  /// Initializes the logger service.
  /// This could involve setting up connections to remote logging services.
  Future<void> init();

  /// Logs a message with a given log level.
  ///
  /// [message] The primary message to log.
  /// [level] The severity of the message.
  /// [error] An optional error object associated with the log.
  /// [stackTrace] An optional stack trace associated with the error.
  /// [context] Optional additional context, typically a Map<String, dynamic>.
  void log(
    String message, {
    LogLevel level = LogLevel.info,
    dynamic error,
    StackTrace? stackTrace,
    Map<String, dynamic>? context,
  });

  // Convenience methods for each log level

  void debug(String message, {Map<String, dynamic>? context}) {
    log(message, level: LogLevel.debug, context: context);
  }

  void info(String message, {Map<String, dynamic>? context}) {
    log(message, level: LogLevel.info, context: context);
  }

  void warning(String message, {dynamic error, StackTrace? stackTrace, Map<String, dynamic>? context}) {
    log(message, level: LogLevel.warning, error: error, stackTrace: stackTrace, context: context);
  }

  void error(String message, {dynamic error, StackTrace? stackTrace, Map<String, dynamic>? context}) {
    log(message, level: LogLevel.error, error: error, stackTrace: stackTrace, context: context);
  }

  void fatal(String message, {dynamic error, StackTrace? stackTrace, Map<String, dynamic>? context}) {
    log(message, level: LogLevel.fatal, error: error, stackTrace: stackTrace, context: context);
  }

  /// Sets user information for richer context in logs (e.g., in Sentry).
  void setUserContext({String? id, String? username, String? email, Map<String, dynamic>? extraInfo});

  /// Clears user information.
  void clearUserContext();

  /// Adds a breadcrumb for tracking user actions or events leading up to an error.
  void addBreadcrumb(String message, {String? category, Map<String, dynamic>? data});
}
