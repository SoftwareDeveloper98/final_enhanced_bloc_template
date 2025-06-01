import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import '../models/user_model.dart'; // For potential caching of user details
import '../../../../core/network/exceptions.dart';


abstract class AuthLocalDataSource {
  Future<void> cacheToken({required String token, String? refreshToken});
  Future<String?>getToken();
  Future<String?>getRefreshToken();
  Future<void> clearTokens();
  // Future<UserModel?> getLastUser(); // Example for caching user
  // Future<void> cacheUser(UserModel user);
}

@LazySingleton(as: AuthLocalDataSource)
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage _secureStorage;
  static const String _authTokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  // static const String _cachedUserKey = 'cached_user';


  AuthLocalDataSourceImpl(this._secureStorage);

  @override
  Future<void> cacheToken({required String token, String? refreshToken}) async {
    try {
      await _secureStorage.write(key: _authTokenKey, value: token);
      if (refreshToken != null) {
        await _secureStorage.write(key: _refreshTokenKey, value: refreshToken);
      }
    } catch (e) {
      throw CacheException(message: 'Failed to cache token: ${e.toString()}');
    }
  }

  @override
  Future<String?> getToken() async {
    try {
      return await _secureStorage.read(key: _authTokenKey);
    } catch (e) {
      throw CacheException(message: 'Failed to get token: ${e.toString()}');
    }
  }

  @override
  Future<String?> getRefreshToken() async {
     try {
      return await _secureStorage.read(key: _refreshTokenKey);
    } catch (e) {
      throw CacheException(message: 'Failed to get refresh token: ${e.toString()}');
    }
  }


  @override
  Future<void> clearTokens() async {
    try {
      await _secureStorage.delete(key: _authTokenKey);
      await _secureStorage.delete(key: _refreshTokenKey);
      // await _secureStorage.delete(key: _cachedUserKey);
    } catch (e) {
      throw CacheException(message: 'Failed to clear tokens: ${e.toString()}');
    }
  }

  // Example user caching (optional)
  // @override
  // Future<void> cacheUser(UserModel user) async {
  //   try {
  //     await _secureStorage.write(key: _cachedUserKey, value: json.encode(user.toJson()));
  //   } catch (e) {
  //     throw CacheException(message: 'Failed to cache user: ${e.toString()}');
  //   }
  // }

  // @override
  // Future<UserModel?> getLastUser() async {
  //   try {
  //     final jsonString = await _secureStorage.read(key: _cachedUserKey);
  //     if (jsonString != null) {
  //       return UserModel.fromJson(json.decode(jsonString));
  //     }
  //     return null;
  //   } catch (e) {
  //     throw CacheException(message: 'Failed to get last user: ${e.toString()}');
  //   }
  // }
}
