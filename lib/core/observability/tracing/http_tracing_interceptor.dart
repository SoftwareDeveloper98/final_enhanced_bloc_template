import 'package:http/http.dart' as http;
import 'package:my_app/core/observability/tracing/trace_context_service.dart';
// import 'package:my_app/core/di/service_locator.dart'; // If using GetIt directly

// Note: If using Dio, this would be an `Interceptor` from `dio/dio.dart`.
// This example is for `package:http`.

class HttpTracingInterceptor extends http.BaseClient {
  final http.Client _inner;
  final TraceContextService traceService;
  // final LoggerService logger; // Optional: if direct logging is needed here

  HttpTracingInterceptor({
    required http.Client innerClient,
    required this.traceService,
    // required this.logger, // Pass if needed
  }) : _inner = innerClient;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final stopwatch = Stopwatch()..start();
    // Try to get a parent trace ID if one is already active (e.g., from an UI interaction)
    final parentTraceId = traceService.getCurrentTraceId();
    final operationName = 'HTTP ${request.method}';
    // Start a new trace span for this HTTP request
    final traceId = traceService.startTrace(parentTraceId: parentTraceId, operationName: operationName);

    // Add trace propagation headers
    final traceHeaders = traceService.getPropagationHeaders();
    request.headers.addAll(traceHeaders);

    traceService.addTraceAttributes(traceId, {
      'http.method': request.method,
      'http.url': request.url.toString(),
      'http.request.headers': request.headers.toString(), // Be mindful of sensitive data
    });

    // logger.debug('HTTP Request: ${request.method} ${request.url} with Trace ID: $traceId', context: {'traceId': traceId});

    try {
      final response = await _inner.send(request);
      stopwatch.stop();

      traceService.addTraceAttributes(traceId, {
        'http.status_code': response.statusCode,
        'http.response.headers': response.headers.toString(), // Be mindful of sensitive data
        'http.duration_ms': stopwatch.elapsedMilliseconds,
      });
      // logger.debug(
      //   'HTTP Response: ${response.statusCode} for ${request.url} (Trace ID: $traceId, Duration: ${stopwatch.elapsedMilliseconds}ms)',
      //   context: {'traceId': traceId}
      // );
      traceService.endTrace(traceId, status: 'OK');
      return response;
    } catch (e, s) {
      stopwatch.stop();
      // logger.error(
      //   'HTTP Error: ${request.method} ${request.url} (Trace ID: $traceId, Duration: ${stopwatch.elapsedMilliseconds}ms)',
      //   error: e,
      //   stackTrace: s,
      //   context: {'traceId': traceId}
      // );
      traceService.addTraceAttributes(traceId, {
        'error': true,
        'error.type': e.runtimeType.toString(),
        'error.message': e.toString(),
        'http.duration_ms': stopwatch.elapsedMilliseconds,
      });
      traceService.endTrace(traceId, status: 'ERROR');
      rethrow;
    }
  }
}

/*
Example of how this might be used with http.Client:

void main() async {
  // Assume sl is your GetIt service locator instance
  // await configureDependencies('dev'); // Setup DI

  final logger = sl<LoggerService>();
  final traceContextService = sl<TraceContextService>();

  final httpClient = HttpTracingInterceptor(
    innerClient: http.Client(),
    traceService: traceContextService,
    // logger: logger, // if the interceptor needs it
  );

  try {
    final response = await httpClient.get(Uri.parse('https://api.example.com/data'));
    print('Response status: ${response.statusCode}');
    // final body = await response.stream.bytesToString(); // For StreamedResponse
    // print('Response body: $body');
  } catch (e) {
    print('HTTP request failed: $e');
  } finally {
    httpClient.close();
  }
}
*/

/*
For Dio, the structure would be:
import 'package:dio/dio.dart';
import 'package:my_app/core/observability/tracing/trace_context_service.dart';

class DioHttpTracingInterceptor extends Interceptor {
  final TraceContextService traceService;

  DioHttpTracingInterceptor({required this.traceService});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final stopwatch = Stopwatch()..start();
    options.extra['stopwatch'] = stopwatch; // Store stopwatch in extra

    final parentTraceId = traceService.getCurrentTraceId();
    final traceId = traceService.startTrace(parentTraceId: parentTraceId, operationName: 'HTTP ${options.method}');
    options.extra['traceId'] = traceId; // Store traceId

    final traceHeaders = traceService.getPropagationHeaders();
    options.headers.addAll(traceHeaders);

    traceService.addTraceAttributes(traceId, {
      'http.method': options.method,
      'http.url': options.uri.toString(),
      'http.request.headers': options.headers.toString().substring(0, 500), // Truncate
    });
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final stopwatch = response.requestOptions.extra['stopwatch'] as Stopwatch..stop();
    final traceId = response.requestOptions.extra['traceId'] as String;

    traceService.addTraceAttributes(traceId, {
      'http.status_code': response.statusCode,
      'http.response.headers': response.headers.toString().substring(0, 500), // Truncate
      'http.duration_ms': stopwatch.elapsedMilliseconds,
    });
    traceService.endTrace(traceId, status: 'OK');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final stopwatch = err.requestOptions.extra['stopwatch'] as Stopwatch..stop();
    final traceId = err.requestOptions.extra['traceId'] as String;

    traceService.addTraceAttributes(traceId, {
      'error': true,
      'error.type': err.type.toString(),
      'error.message': err.message ?? err.error.toString(),
      'http.duration_ms': stopwatch.elapsedMilliseconds,
      if (err.response != null) 'http.status_code': err.response!.statusCode,
    });
    traceService.endTrace(traceId, status: 'ERROR');
    super.onError(err, handler);
  }
}
*/
