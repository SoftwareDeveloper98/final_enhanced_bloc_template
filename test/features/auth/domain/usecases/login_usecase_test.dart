import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_app/core/common/error/failures.dart';
import 'package:my_app/features/auth/domain/entities/user_entity.dart';
import 'package:my_app/features/auth/domain/usecases/login_usecase.dart';
// Import from the local test utilities package
import 'package:core_test_utils/core_test_utils.dart';

// MockAuthRepository is already defined in core_test_utils

void main() {
  late LoginUseCase usecase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = LoginUseCase(mockAuthRepository);
    // Register a fallback value for any types used with `any(named: ...)`
    registerFallbackValue(const LoginParams(email: '', password: ''));
  });

  const tEmail = 'test@example.com';
  const tPassword = 'password123';
  final tLoginParams = LoginParams(email: tEmail, password: tPassword);

  // Use the generator from core_test_utils
  final tUserEntity = createFakeUserEntity(
    id: '1',
    email: tEmail,
    name: 'Test User',
  );

  test('should get user entity from the repository upon successful login', () async {
    // Arrange
    // Stub the login method on the mock repository to return a Right(tUserEntity)
    when(() => mockAuthRepository.login(
      email: any(named: 'email'),
      password: any(named: 'password'),
    )).thenAnswer((_) async => Right(tUserEntity));

    // Act
    final result = await usecase(tLoginParams);

    // Assert
    // Expect the result to be a Right containing the tUserEntity
    expect(result, Right(tUserEntity));
    // Verify that the login method on the repository was called once with the correct parameters
    verify(() => mockAuthRepository.login(email: tEmail, password: tPassword)).called(1);
    // Ensure no other methods were called on the repository
    verifyNoMoreInteractions(mockAuthRepository);
  });

  test('should return a ServerFailure when the login call is unsuccessful', () async {
    // Arrange
    const tServerFailure = ServerFailure(message: 'Login Failed');
    when(() => mockAuthRepository.login(
      email: any(named: 'email'),
      password: any(named: 'password'),
    )).thenAnswer((_) async => const Left(tServerFailure));

    // Act
    final result = await usecase(tLoginParams);

    // Assert
    expect(result, const Left(tServerFailure));
    verify(() => mockAuthRepository.login(email: tEmail, password: tPassword)).called(1);
    verifyNoMoreInteractions(mockAuthRepository);
  });
}
