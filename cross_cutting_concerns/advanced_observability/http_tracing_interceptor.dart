// Basic structure for HTTP Tracing Interceptor
// Actual implementation will depend on the specific tracing library (e.g., OpenTelemetry)

import 'package:http/http.dart' as http;

class HttpTracingInterceptor extends http.BaseClient {
  final http.Client _inner;

  HttpTracingInterceptor(this._inner);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    // Start a new trace span
    // Add trace headers to the request
    // Record request details (URL, method, headers)

    try {
      final response = await _inner.send(request);
      // Record response details (status code, headers)
      // End the trace span
      return response;
    } catch (e) {
      // Record error details
      // End the trace span with error status
      rethrow;
    }
  }
}
