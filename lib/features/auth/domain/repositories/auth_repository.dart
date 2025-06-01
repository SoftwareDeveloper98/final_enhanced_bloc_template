import 'package:dartz/dartz.dart'; // For Either
import '../../../../core/common/error/failures.dart'; // Assuming Failure class is in core
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, UserEntity>> getCurrentUser();

  // Future<Either<Failure, void>> signup({
  //   required String email,
  //   required String password,
  //   String? name,
  // });

  // Future<Either<Failure, void>> forgotPassword(String email);
}
