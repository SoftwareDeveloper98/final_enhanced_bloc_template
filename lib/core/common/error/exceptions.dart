/// Represents exceptions originating from the server during API calls.
class ServerException implements Exception {
  final String message;
  ServerException({this.message = "An error occurred on the server."});
}

/// Represents exceptions originating from the local cache (e.g., Hive).
class CacheException implements Exception {
  final String message;
  CacheException({this.message = "An error occurred accessing the cache."});
}

/// Represents exceptions related to network connectivity.
class NetworkException implements Exception {
  final String message;
  NetworkException({this.message = "Network error occurred. Please check your connection."});
}

/// Represents exceptions during input validation.
class ValidationException implements Exception {
  final String message;
  ValidationException({this.message = "Input validation failed."});
}

/// Represents any other unexpected exceptions.
class UnknownException implements Exception {
  final String message;
  UnknownException({this.message = "An unknown error occurred."});
}

