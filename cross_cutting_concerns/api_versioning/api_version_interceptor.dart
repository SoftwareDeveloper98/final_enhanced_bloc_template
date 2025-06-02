// Basic structure for API Versioning Interceptor
// This interceptor will add the API version to the request headers

import 'package:http/http.dart' as http;

class ApiVersionInterceptor extends http.BaseClient {
  final http.Client _inner;
  final String apiVersion;

  ApiVersionInterceptor(this._inner, this.apiVersion);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    request.headers['X-API-Version'] = apiVersion;
    return _inner.send(request);
  }
}
