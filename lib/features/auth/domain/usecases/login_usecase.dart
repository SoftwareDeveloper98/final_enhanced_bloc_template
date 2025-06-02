import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart'; // For LoginParams
import 'package:my_app/core/common/error/failures.dart';
import 'package:my_app/core/common/usecases/usecase.dart';
import 'package:my_app/features/auth/domain/entities/user_profile.dart';
import 'package:my_app/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase implements UseCase<UserProfile, LoginParams> {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  @override
  Future<Either<Failure, UserProfile>> call(LoginParams params) async {
    // Here you could add validation for params.email and params.password if needed,
    // or this can be handled at the UI/Presentation layer.
    // For example:
    // if (!isValidEmail(params.email)) {
    //   return Left(ValidationFailure(message: 'Invalid email format'));
    // }
    // if (params.password.length < 6) {
    //   return Left(ValidationFailure(message: 'Password too short'));
    // }
    return await repository.login(params.email, params.password);
  }
}

class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}
