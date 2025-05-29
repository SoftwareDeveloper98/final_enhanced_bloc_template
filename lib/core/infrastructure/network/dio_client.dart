import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart'; // Import logger

import '../../../app/di/injector.dart'; // To get logger instance
import '../../common/error/exceptions.dart'; // Import custom exceptions
import '../../main_common.dart'; // Import environment constants

@module
abstract class NetworkModule {
  @lazySingleton
  Dio dio(
    @Named('BaseUrl') String baseUrl,
    Logger logger, // Inject logger
  ) {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 15), // Increased timeout
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: logger.d, // Use logger for Dio logs
    ));
    dio.interceptors.add(_AuthInterceptor(logger)); // Pass logger
    dio.interceptors.add(_ErrorInterceptor(logger)); // Add error interceptor
    // TODO: Add retry interceptor if needed (e.g., using dio_smart_retry package)

    return dio;
  }

  // Environment-specific base URL registration
  @prod
  @Named('BaseUrl')
  String get prodBaseUrl => 'https://api.prod.example.com';

  @dev
  @Named('BaseUrl')
  String get devBaseUrl => 'https://api.dev.example.com';

  // Add staging or other environments if needed
}

// Authentication Interceptor
class _AuthInterceptor extends Interceptor {
  final Logger logger;
  _AuthInterceptor(this.logger);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    logger.i('AuthInterceptor: Adding token if available...');
    // TODO: Implement secure token retrieval logic
    const String? token = null; // Replace with actual token retrieval
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
      logger.d('AuthInterceptor: Token added.');
    } else {
      logger.w('AuthInterceptor: No token found.');
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    logger.w('AuthInterceptor: Handling error - Status Code: ${err.response?.statusCode}');
    if (err.response?.statusCode == 401) {
      logger.e('AuthInterceptor: Unauthorized error (401). Implement token refresh or logout.');
      // TODO: Implement token refresh logic or navigate to login
    }
    // Important: Call super.onError to allow other interceptors (like _ErrorInterceptor) to handle it.
    super.onError(err, handler);
  }
}

// Error Handling Interceptor
class _ErrorInterceptor extends Interceptor {
  final Logger logger;
  _ErrorInterceptor(this.logger);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    logger.e(
      'ErrorInterceptor: DioException caught!',
      error: err,
      stackTrace: err.stackTrace,
    );

    // Map DioException to custom ServerException or NetworkException
    final exception = _mapDioErrorToException(err);

    // Create a new DioException with the custom exception to pass it along
    // This allows the repository layer to catch specific custom exceptions
    final customError = DioException(
      requestOptions: err.requestOptions,
      response: err.response,
      type: err.type,
      error: exception, // Embed the custom exception here
      stackTrace: err.stackTrace,
      message: exception.message,
    );

    logger.w('ErrorInterceptor: Mapped DioException to ${exception.runtimeType}');
    handler.next(customError); // Pass the modified error
  }

  Exception _mapDioErrorToException(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException(message: 'Connection timeout. Please check your internet connection.');
      case DioExceptionType.badResponse:
        // Map based on status code
        final statusCode = err.response?.statusCode;
        // You can add more specific status code mappings here
        if (statusCode == 400) {
          return ServerException(message: 'Bad request (400).');
        } else if (statusCode == 401) {
          // This might be handled by AuthInterceptor first, but good to have a fallback
          return ServerException(message: 'Unauthorized (401). Please login again.');
        } else if (statusCode == 403) {
          return ServerException(message: 'Forbidden (403). You do not have permission.');
        } else if (statusCode == 404) {
          return ServerException(message: 'Resource not found (404).');
        } else if (statusCode != null && statusCode >= 500) {
          return ServerException(message: 'Server error ($statusCode). Please try again later.');
        }
        return ServerException(message: 'Received invalid status code: ${err.response?.statusCode}');
      case DioExceptionType.cancel:
        return NetworkException(message: 'Request cancelled.');
      case DioExceptionType.connectionError:
         return NetworkException(message: 'Connection error. Please check your internet connection.');
      case DioExceptionType.unknown:
      default:
        // Check if the error is a custom exception already (e.g., from AuthInterceptor)
        if (err.error is Exception) {
          return err.error as Exception;
        }
        return UnknownException(message: 'An unexpected network error occurred.');
    }
  }
}

