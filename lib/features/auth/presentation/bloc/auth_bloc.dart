import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/bloc/base_bloc.dart'; // Our BaseBloc
import '../../../../core/bloc/base_state.dart'; // Our BaseState for common states
import '../../../../core/common/error/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/use_cases/login_use_case.dart';
// Import other use cases like LogoutUseCase, GetCurrentUserUseCase when created

part 'auth_event.dart';
part 'auth_state.dart';

@injectable // Or @lazySingleton if appropriate
class AuthBloc extends BaseBloc<AuthEvent, AuthState> {
  final LoginUseCase _loginUseCase;
  // final LogoutUseCase _logoutUseCase;
  // final GetCurrentUserUseCase _getCurrentUserUseCase;

  AuthBloc(
    this._loginUseCase,
    // this._logoutUseCase,
    // this._getCurrentUserUseCase,
  ) : super(const AuthInitial()) { // Initial state can be AuthInitial or Unauthenticated
    // Register event handlers here if not using the default _eventTransformer from BaseBloc
    // OR rely on handleEvent override.
  }

  @override
  Future<void> handleEvent(AuthEvent event, Emitter<AuthState> emit) async {
    if (event is LoginSubmitted) {
      await _handleLoginSubmitted(event, emit);
    } else if (event is LogoutRequested) {
      await _handleLogoutRequested(event, emit);
    } else if (event is CheckAuthStatus) {
      await _handleCheckAuthStatus(event, emit);
    }
  }

  Future<void> _handleLoginSubmitted(LoginSubmitted event, Emitter<AuthState> emit) async {
    emit(const AuthLoading(message: 'Attempting login...'));
    final result = await _loginUseCase(LoginParams(email: event.email, password: event.password));
    result.fold(
      (failure) => emit(AuthError(message: _mapFailureToMessage(failure), details: failure.toString())),
      (user) => emit(Authenticated(user: user)),
    );
  }

  Future<void> _handleLogoutRequested(LogoutRequested event, Emitter<AuthState> emit) async {
    emit(const AuthLoading(message: 'Logging out...'));
    // Assuming LogoutUseCase exists and works similarly:
    // final result = await _logoutUseCase(NoParams());
    // result.fold(
    //   (failure) => emit(AuthError(message: _mapFailureToMessage(failure), details: failure.toString())),
    //   (_) => emit(const Unauthenticated()),
    // );
    // For now, simulate logout success:
    // In a real app, clear local tokens via a use case that calls the repository.
    // This is simplified here. The AuthRepositoryImpl.logout() clears tokens.
    // A LogoutUseCase would call that.
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate async work
    emit(const Unauthenticated());
  }

  Future<void> _handleCheckAuthStatus(CheckAuthStatus event, Emitter<AuthState> emit) async {
    emit(const AuthLoading(message: 'Checking authentication...'));
    // Assuming GetCurrentUserUseCase exists:
    // final result = await _getCurrentUserUseCase(NoParams());
    // result.fold(
    //   (failure) {
    //     if (failure is AuthenticationFailure) {
    //       emit(const Unauthenticated());
    //     } else {
    //       emit(AuthError(message: _mapFailureToMessage(failure), details: failure.toString()));
    //     }
    //   },
    //   (user) => emit(Authenticated(user: user)),
    // );
    // For now, simulate checking status and finding unauthenticated:
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate async work
    emit(const Unauthenticated()); // Default to unauthenticated
  }

  // Override handleError from BaseBloc if more specific AuthError states are needed
  // or if AuthState doesn't directly use the base ErrorState.
  // For now, BaseBloc's handleError will emit an ErrorState, which AuthError can receive.
  // We defined AuthError to match ErrorState structure.

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server Error: ${failure.message}';
      case CacheFailure:
        return 'Cache Error: ${failure.message}';
      case NetworkFailure:
        return 'Network Error: ${failure.message}';
      case AuthenticationFailure:
        return 'Authentication Error: ${failure.message}';
      default:
        return 'An unexpected error occurred: ${failure.message}';
    }
  }
}
