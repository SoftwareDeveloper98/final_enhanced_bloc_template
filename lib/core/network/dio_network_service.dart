import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'network_service.dart';
import 'exceptions.dart';
import '../di/service_locator.dart'; // For environment checks

// Placeholder for a logger, replace with actual logger from core/logging later
class _Logger {
  void info(String message) => print('[INFO] $message');
  void error(String message, [dynamic e, StackTrace? st]) => print('[ERROR] $message ${e?.toString()}');
}

@LazySingleton(as: NetworkService)
@Injectable(as: NetworkService) // Add this if you want to register it directly too
class DioNetworkService implements NetworkService {
  final Dio _dio;
  final FlutterSecureStorage _secureStorage;
  final _Logger _logger = _Logger(); // Replace with actual logger

  // TODO: Inject these via constructor or DI
  final String _baseUrl = const String.fromEnvironment('BASE_URL', defaultValue: 'https://api.example.com');
  // final String _apiKey = const String.fromEnvironment('API_KEY'); // Example

  DioNetworkService(this._secureStorage) : _dio = Dio() {
    _dio.options.baseUrl = _baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 15);
    _dio.options.receiveTimeout = const Duration(seconds: 15);

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        _logger.info('--> ${options.method} ${options.uri}');
        // Log headers and body if needed (careful with sensitive data)
        // _logger.info('Headers: ${options.headers}');
        // _logger.info('Body: ${options.data}');

        // Get token from secure storage
        final token = await _secureStorage.read(key: 'auth_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        // options.headers['X-Api-Key'] = _apiKey; // If using API key
        return handler.next(options);
      },
      onResponse: (response, handler) {
        _logger.info('<-- ${response.statusCode} ${response.requestOptions.method} ${response.requestOptions.uri}');
        // Log body if needed
        // _logger.info('Response Body: ${response.data}');
        return handler.next(response);
      },
      onError: (DioException e, handler) async {
        _logger.error('<-- DioError: ${e.message}', e, e.stackTrace);
        _logger.error('Error Response: ${e.response?.data}');

        if (e.response?.statusCode == 401) {
          _logger.info('Attempting token refresh...');
          try {
            final newToken = await _refreshToken();
            if (newToken != null) {
              await _secureStorage.write(key: 'auth_token', value: newToken);
              // Clone the request and retry
              final newOptions = Options(
                method: e.requestOptions.method,
                headers: e.requestOptions.headers..['Authorization'] = 'Bearer $newToken',
              );
              final response = await _dio.request(
                e.requestOptions.path,
                data: e.requestOptions.data,
                queryParameters: e.requestOptions.queryParameters,
                options: newOptions,
              );
              return handler.resolve(response);
            } else {
               _logger.error('Token refresh failed, new token is null.');
               await _secureStorage.delete(key: 'auth_token'); // Clear invalid token
               await _secureStorage.delete(key: 'refresh_token');
               // Optionally, navigate to login or broadcast auth failure event
               return handler.reject(DioException(
                 requestOptions: e.requestOptions,
                 error: UnauthorizedException(message: 'Token refresh failed, please login again.'),
                 response: e.response,
               ));
            }
          } catch (refreshError) {
            _logger.error('Error during token refresh: $refreshError');
            await _secureStorage.delete(key: 'auth_token');
            await _secureStorage.delete(key: 'refresh_token');
            return handler.reject(DioException(
              requestOptions: e.requestOptions,
              error: UnauthorizedException(message: 'Session expired, please login again.'),
              response: e.response,
            ));
          }
        }
        // TODO: Add retry logic for transient errors (e.g., 5xx, network issues)
        return handler.next(e);
      },
    ));
  }

  Future<String?> _refreshToken() async {
    // This is a simplified refresh token logic.
    // In a real app, you'd make a call to your auth server's refresh token endpoint.
    final refreshToken = await _secureStorage.read(key: 'refresh_token');
    if (refreshToken == null) {
      _logger.info('No refresh token found.');
      return null;
    }

    try {
      // IMPORTANT: Replace with your actual token refresh API call
      _logger.info('Calling refresh token endpoint with token: $refreshToken');
      final response = await Dio().post(
        '$_baseUrl/auth/refresh', // Ensure this is your actual refresh endpoint
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200 && response.data['accessToken'] != null) {
        final newAccessToken = response.data['accessToken'] as String;
        final newRefreshToken = response.data['refreshToken'] as String?; // Optional: if backend sends new refresh token
        if (newRefreshToken != null) {
           await _secureStorage.write(key: 'refresh_token', value: newRefreshToken);
        }
        _logger.info('Token refresh successful. New access token obtained.');
        return newAccessToken;
      } else {
        _logger.error('Refresh token API call failed or returned invalid data. Status: ${response.statusCode}, Data: ${response.data}');
        return null;
      }
    } catch (e) {
      _logger.error('Exception during token refresh API call: $e');
      return null;
    }
  }

  @override
  Future<dynamic> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw NetworkException(message: 'Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<dynamic> post(String path, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.post(path, data: data, queryParameters: queryParameters);
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw NetworkException(message: 'Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<dynamic> put(String path, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.put(path, data: data, queryParameters: queryParameters);
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw NetworkException(message: 'Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<dynamic> delete(String path, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.delete(path, data: data, queryParameters: queryParameters);
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw NetworkException(message: 'Unexpected error: ${e.toString()}');
    }
  }

  Exception _handleDioError(DioException e) {
    if (e.error is UnauthorizedException) {
      return e.error as UnauthorizedException;
    }
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionError) {
      return NetworkException(message: 'Connection error: ${e.message}');
    }
    if (e.response != null) {
      if (e.response!.statusCode == 401) {
        return UnauthorizedException(message: 'Unauthorized: ${e.response!.data?['message'] ?? 'Invalid credentials'}');
      }
      return ServerException(
        message: 'Server error: ${e.response!.data?['message'] ?? 'Unknown server error'}',
        statusCode: e.response!.statusCode,
      );
    }
    return NetworkException(message: 'Unexpected Dio error: ${e.message}');
  }
}
