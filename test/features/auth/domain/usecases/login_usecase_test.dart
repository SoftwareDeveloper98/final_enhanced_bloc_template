import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_app/core/common/error/failures.dart';
import 'package:my_app/features/auth/domain/entities/user_profile.dart';
import 'package:my_app/features/auth/domain/usecases/login_usecase.dart';
// Import from the local test utilities package
import 'package:core_test_utils/core_test_utils.dart';

// MockAuthRepository is already defined in core_test_utils

// A fake for LoginParams if it were more complex and needed custom behavior for testing.
// Since LoginParams is simple and uses Equatable, direct instantiation is fine.
// If LoginParams had methods or complex logic, a Fake might be useful.
// class FakeLoginParams extends Fake implements LoginParams {}

void main() {
  late LoginUseCase usecase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = LoginUseCase(mockAuthRepository);
    // For LoginParams, since it's simple, we don't need to register a fallback for fakes.
    // If it were complex: registerFallbackValue(FakeLoginParams());
  });

  const tEmail = 'test@example.com';
  const tPassword = 'password123';
  final tLoginParams = LoginParams(email: tEmail, password: tPassword);

  // Use the generator from core_test_utils
  final tUserProfile = createFakeUserProfile(
    id: '1',
    email: tEmail,
    name: 'Test User',
  );

  test('should get user profile from the repository upon successful login', () async {
    // Arrange
    // Stub the login method on the mock repository to return a Right(tUserProfile)
    // when called with any String arguments for email and password.
    // Using any() for email and password here for simplicity, or match tEmail, tPassword.
    when(() => mockAuthRepository.login(any(), any()))
        .thenAnswer((_) async => Right(tUserProfile));
    // Alternatively, to be more specific with parameters:
    // when(() => mockAuthRepository.login(tEmail, tPassword))
    //     .thenAnswer((_) async => Right(tUserProfile));

    // Act
    final result = await usecase(tLoginParams);

    // Assert
    // Expect the result to be a Right containing the tUserProfile
    expect(result, Right(tUserProfile));
    // Verify that the login method on the repository was called once with the correct parameters
    verify(() => mockAuthRepository.login(tEmail, tPassword)).called(1);
    // Ensure no other methods were called on the repository
    verifyNoMoreInteractions(mockAuthRepository);
  });

  test('should return a ServerFailure when the login call is unsuccessful', () async {
    // Arrange
    const tServerFailure = ServerFailure(message: 'Login Failed');
    when(() => mockAuthRepository.login(any(), any()))
        .thenAnswer((_) async => const Left(tServerFailure));

    // Act
    final result = await usecase(tLoginParams);

    // Assert
    expect(result, const Left(tServerFailure));
    verify(() => mockAuthRepository.login(tEmail, tPassword)).called(1);
    verifyNoMoreInteractions(mockAuthRepository);
  });
}
