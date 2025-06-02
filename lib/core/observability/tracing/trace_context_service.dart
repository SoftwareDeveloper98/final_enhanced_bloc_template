import 'package:my_app/core/observability/logging/logger_service.dart';
import 'package:uuid/uuid.dart'; // TODO: Add uuid: ^4.3.3 (or latest) to pubspec.yaml

// --- Abstract Trace Context Service ---
abstract class TraceContextService {
  /// Starts a new trace, generating a unique trace ID.
  /// Returns the trace ID.
  String startTrace({String? parentTraceId, String? operationName});

  /// Ends the current trace.
  void endTrace(String traceId, {String? status, Map<String, dynamic>? attributes});

  /// Gets the current active trace ID.
  /// This might return null if no trace is active.
  String? getCurrentTraceId();

  /// Gets the current active span ID (if applicable, for more granular tracing).
  /// This might return null if no span is active or not supported.
  String? getCurrentSpanId();

  /// Adds attributes/tags to the current trace.
  void addTraceAttributes(String traceId, Map<String, dynamic> attributes);

  /// Creates HTTP headers needed to propagate trace context to downstream services.
  Map<String, String> getPropagationHeaders();
}

// --- Logging-based Implementation of Trace Context Service ---
class LoggingTraceContextService implements TraceContextService {
  final LoggerService logger;
  final Uuid _uuid = const Uuid();
  String? _activeTraceId;
  String? _activeSpanId; // Simple span concept for this logger

  LoggingTraceContextService({required this.logger});

  @override
  String startTrace({String? parentTraceId, String? operationName}) {
    _activeTraceId = parentTraceId ?? _uuid.v4();
    _activeSpanId = _uuid.v4(); // Each "trace" start also starts a new "span" here
    final opName = operationName ?? 'unnamed_operation';
    logger.info(
      'Trace Started: ID=$_activeTraceId, Span=$_activeSpanId, Operation=$opName',
      context: {'traceId': _activeTraceId, 'spanId': _activeSpanId, 'parentTraceId': parentTraceId, 'operation': opName},
    );
    return _activeTraceId!;
  }

  @override
  void endTrace(String traceId, {String? status, Map<String, dynamic>? attributes}) {
    if (traceId != _activeTraceId) {
      logger.warning('Attempted to end trace $traceId but active trace is $_activeTraceId');
      return;
    }
    final context = <String, dynamic>{
      'traceId': traceId,
      'spanId': _activeSpanId, // Log the span that's ending with this trace
      if (status != null) 'status': status,
      if (attributes != null) ...attributes,
    };
    logger.info('Trace Ended: ID=$traceId, Status=${status ?? "unknown"}', context: context);
    _activeTraceId = null;
    _activeSpanId = null;
  }

  @override
  String? getCurrentTraceId() {
    return _activeTraceId;
  }

  @override
  String? getCurrentSpanId() {
    return _activeSpanId;
  }

  @override
  void addTraceAttributes(String traceId, Map<String, dynamic> attributes) {
    if (traceId != _activeTraceId) {
      logger.warning('Cannot add attributes to trace $traceId, active trace is $_activeTraceId');
      return;
    }
    logger.info('Adding attributes to trace $traceId: $attributes', context: {'traceId': traceId, 'attributes': attributes});
    // In a real system, these attributes would be attached to the trace span.
  }

  @override
  Map<String, String> getPropagationHeaders() {
    if (_activeTraceId != null && _activeSpanId != null) {
      // Example using a common header format like W3C Trace Context (simplified)
      // 'traceparent': '00-${_activeTraceId}-${_activeSpanId}-01' (version-traceid-spanid-flags)
      // This is a simplified version. Real W3C TraceContext has specific formats.
      final headers = {
        'X-Trace-ID': _activeTraceId!,
        'X-Span-ID': _activeSpanId!,
      };
      logger.debug('Generated propagation headers: $headers', context: {'traceId': _activeTraceId});
      return headers;
    }
    return {};
  }
}
