part of 'auth_bloc.dart'; // Using part/part of for same library

abstract class AuthState extends BaseState { // Extends BaseState from core
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState { // Extends AuthState
  const AuthInitial();
}

class AuthLoading extends AuthState { // Extends AuthState
   final String? message;
   const AuthLoading({this.message}) : super();
   @override List<Object?> get props => [message];
}

class Authenticated extends AuthState { // Extends AuthState
  final UserEntity user;
  const Authenticated({required this.user});

  @override
  List<Object?> get props => [user];
}

class Unauthenticated extends AuthState { // Extends AuthState
  const Unauthenticated();
}

class AuthError extends AuthState { // Extends AuthState
    final String message;
    final String? details;
    const AuthError({required this.message, this.details});

    @override
    List<Object?> get props => [message, details];
}
