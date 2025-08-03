import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_app/core/common/error/failures.dart';
import 'package:my_app/features/auth/domain/entities/user_entity.dart';
import 'package:my_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:my_app/features/auth/presentation/bloc/auth_bloc.dart';

// Mocks using Mocktail
class MockLoginUseCase extends Mock implements LoginUseCase {}

void main() {
  late AuthBloc authBloc;
  late MockLoginUseCase mockLoginUseCase;

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    authBloc = AuthBloc(mockLoginUseCase);
    // Register fallback value for LoginParams
    registerFallbackValue(const LoginParams(email: '', password: ''));
  });

  tearDown(() {
    authBloc.close();
  });

  const tEmail = 'test@example.com';
  const tPassword = 'password123';
  final tUserEntity = UserEntity(id: '1', email: tEmail, name: 'Test User');
  const tServerFailure = ServerFailure(message: 'Invalid credentials');

  test('initial state should be AuthInitial', () {
    expect(authBloc.state, const AuthInitial());
  });

  group('LoginSubmitted', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, Authenticated] when login is successful',
      build: () {
        when(() => mockLoginUseCase(any())).thenAnswer((_) async => Right(tUserEntity));
        return authBloc;
      },
      act: (bloc) => bloc.add(const LoginSubmitted(email: tEmail, password: tPassword)),
      expect: () => [
        const AuthLoading(message: 'Attempting login...'),
        Authenticated(user: tUserEntity),
      ],
      verify: (_) {
        verify(() => mockLoginUseCase(const LoginParams(email: tEmail, password: tPassword))).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] when login fails',
      build: () {
        when(() => mockLoginUseCase(any())).thenAnswer((_) async => const Left(tServerFailure));
        return authBloc;
      },
      act: (bloc) => bloc.add(const LoginSubmitted(email: tEmail, password: tPassword)),
      expect: () => [
        const AuthLoading(message: 'Attempting login...'),
        const AuthError(message: 'Server Error: Invalid credentials', details: 'ServerFailure(message: Invalid credentials, code: null)'),
      ],
      verify: (_) {
        verify(() => mockLoginUseCase(const LoginParams(email: tEmail, password: tPassword))).called(1);
      },
    );
  });
}
