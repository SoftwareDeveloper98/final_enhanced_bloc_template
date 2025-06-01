import 'package:injectable/injectable.dart';
import '../../../../core/network/network_service.dart';
import '../../../../core/network/exceptions.dart'; // For specific exception handling
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login({required String email, required String password});
  Future<void> logout(); // Might call a backend endpoint
  // Future<UserModel> getCurrentUser(); // If there's an endpoint for this
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final NetworkService _networkService;

  AuthRemoteDataSourceImpl(this._networkService);

  @override
  Future<UserModel> login({required String email, required String password}) async {
    try {
      // Replace with actual endpoint and request structure
      final response = await _networkService.post(
        '/auth/login', // Placeholder endpoint
        data: {'email': email, 'password': password},
      );
      // Assuming response is like: { "user": {...}, "token": "...", "refreshToken": "..." }
      // Securely store tokens (this might be better handled in repository or a dedicated service after login)
      // For now, let's assume token storage happens elsewhere or is implicitly handled by NetworkService interceptors upon receiving a new token.

      if (response != null && response['user'] != null) {
          return UserModel.fromJson(response['user'] as Map<String, dynamic>);
      } else {
          throw ServerException(message: 'Invalid login response format', statusCode: response?.statusCode);
      }
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Login failed: ${e.toString()}');
    }
  }

  @override
  Future<void> logout() async {
    try {
      // Example: Call a logout endpoint if your backend supports it
      // await _networkService.post('/auth/logout');
      // Token clearing should ideally be handled by a dedicated service or AuthRepository
      print("AuthRemoteDataSourceImpl: User logged out (simulated).");
    } catch (e) {
      // Handle error or log, but logout should generally succeed locally
      print("Error during remote logout: ${e.toString()}");
      throw ServerException(message: 'Logout failed: ${e.toString()}');
    }
  }
}
