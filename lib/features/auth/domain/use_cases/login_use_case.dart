import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/common/error/failures.dart';
import '../../../../core/common/usecases/usecase.dart'; // Base UseCase
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

@lazySingleton
class LoginUseCase implements UseCase<UserEntity, LoginParams> {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  @override
  Future<Either<Failure, UserEntity>> call(LoginParams params) async {
    return await _repository.login(
      email: params.email,
      password: params.password,
    );
  }
}

class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}
