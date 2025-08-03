// lib/features/auth/domain/repositories/auth_repository.dart
import 'package:dartz/dartz.dart';
import 'package:my_app/core/common/error/failures.dart'; // Adjust import if your Failure class is elsewhere
import 'package:my_app/features/auth/domain/entities/user_profile.dart'; // Adjusted to UserProfile

import 'package:my_app/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> login({required String email, required String password});
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, UserEntity>> getCurrentUser();
  // Add other auth methods as needed, e.g.:
  // Future<Either<Failure, UserProfile>> signup(String email, String password, {String? name});
  // Future<Either<Failure, void>> sendPasswordResetEmail(String email);
}
