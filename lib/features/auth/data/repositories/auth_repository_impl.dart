import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/common/error/failures.dart';
import '../../../../core/network/exceptions.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../data_sources/auth_local_data_source.dart';
import '../data_sources/auth_remote_data_source.dart';
// import '../models/user_model.dart'; // If conversion is complex

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;
  // final NetworkInfo networkInfo; // Assuming NetworkInfo utility exists for connectivity check

  AuthRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
    // this.networkInfo,
  );

  @override
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  }) async {
    // if (await networkInfo.isConnected) { // Check network connectivity
    try {
      final userModel = await _remoteDataSource.login(email: email, password: password);
      // Assuming the login response from remote data source might contain tokens
      // which should be cached by the remote data source or this repository.
      // For simplicity, let's assume tokens are handled by interceptors or directly by data sources for now.
      // If login response includes tokens:
      // final token = response.token; // Pseudo-code
      // final refreshToken = response.refreshToken; // Pseudo-code
      // await _localDataSource.cacheToken(token: token, refreshToken: refreshToken);
      // await _localDataSource.cacheUser(userModel); // Cache user details
      return Right(userModel.toEntity()); // Convert UserModel to UserEntity
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.statusCode?.toString()));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on UnauthorizedException catch (e) {
      return Left(AuthenticationFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred during login: ${e.toString()}'));
    }
    // } else {
    //   return Left(NetworkFailure(message: 'No internet connection'));
    // }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      // Perform remote logout if necessary (e.g. invalidate session on server)
      // await _remoteDataSource.logout(); // This might be optional

      // Always clear local tokens and cached data
      await _localDataSource.clearTokens();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred during logout: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    // This is a simplified example. A real app might:
    // 1. Check for a valid token locally.
    // 2. If token exists, try to fetch user profile from backend to validate token.
    // 3. Or, decode token locally if it contains user info (less secure for roles/permissions).
    // 4. Fallback to cached user if offline and token was recently validated.
    try {
      final token = await _localDataSource.getToken();
      if (token == null) {
        return Left(AuthenticationFailure(message: 'Not authenticated. No token found.'));
      }
      // At this point, you might want to validate the token with the backend
      // or fetch user details using the token. For this example, we'll assume
      // if a token exists, we might have cached user data or need a mechanism
      // to fetch it.
      // For now, let's return a placeholder or error, as fetching user by token is not fully implemented.
      // final cachedUser = await _localDataSource.getLastUser();
      // if (cachedUser != null) return Right(cachedUser.toEntity());

      // Placeholder: In a real scenario, you'd fetch user details from an API using the token.
      // For now, if token exists, assume success for demonstration.
      // This should be replaced with actual logic to fetch user from remote or local source based on token.
      // Example:
      // final userModel = await _remoteDataSource.getCurrentUser(); // Assuming such a method exists
      // await _localDataSource.cacheUser(userModel);
      // return Right(userModel.toEntity());

      return Left(ServerFailure(message: "Get current user not fully implemented. Requires API call with token."));

    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Error getting current user: ${e.toString()}'));
    }
  }
}
