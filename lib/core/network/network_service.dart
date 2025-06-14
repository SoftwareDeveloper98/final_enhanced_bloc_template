abstract class NetworkService {
  Future<dynamic> get(String path, {Map<String, dynamic>? queryParameters});
  Future<dynamic> post(String path, {dynamic data, Map<String, dynamic>? queryParameters});
  Future<dynamic> put(String path, {dynamic data, Map<String, dynamic>? queryParameters});
  Future<dynamic> delete(String path, {dynamic data, Map<String, dynamic>? queryParameters});
}
