import 'package:intl/intl.dart'; // For date formatting
import 'package:my_app/core/observability/logging/logger_service.dart';

class ConsoleLogger implements LoggerService {
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');

  @override
  Future<void> init() async {
    // Console logger doesn't require async initialization
    print("${_now()} [INFO] ConsoleLogger initialized.");
  }

  String _now() => _dateFormat.format(DateTime.now());

  @override
  void log(
    String message, {
    LogLevel level = LogLevel.info,
    dynamic error,
    StackTrace? stackTrace,
    Map<String, dynamic>? context,
  }) {
    final timestamp = _now();
    final levelStr = level.toString().split('.').last.toUpperCase();
    final logMessage = StringBuffer("[$timestamp][$levelStr] $message");

    if (context != null) {
      logMessage.write("\n  Context: $context");
    }
    if (error != null) {
      logMessage.write("\n  Error: $error");
    }
    if (stackTrace != null) {
      logMessage.write("\n  StackTrace: \n$stackTrace");
    }

    print(logMessage.toString());
  }

  @override
  void setUserContext({String? id, String? username, String? email, Map<String, dynamic>? extraInfo}) {
    print("${_now()} [INFO] Set User Context: ID=$id, Username=$username, Email=$email, Extra=$extraInfo");
  }

  @override
  void clearUserContext() {
    print("${_now()} [INFO] Cleared User Context.");
  }

  @override
  void addBreadcrumb(String message, {String? category, Map<String, dynamic>? data}) {
    final dataStr = data != null ? " Data: $data" : "";
    final categoryStr = category != null ? " ($category)" : "";
    print("${_now()} [BREADCRUMB]$categoryStr $message$dataStr");
  }
}
