import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_app/core/common/error/failures.dart';
import 'package:my_app/core/network/exceptions.dart';
import 'package:my_app/features/auth/data/data_sources/auth_local_data_source.dart';
import 'package:my_app/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:my_app/features/auth/data/models/user_model.dart';
import 'package:my_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:my_app/features/auth/domain/entities/user_entity.dart';

// Mocks using Mocktail
class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}
class MockAuthLocalDataSource extends Mock implements AuthLocalDataSource {}

void main() {
  late AuthRepositoryImpl repository;
  late MockAuthRemoteDataSource mockRemoteDataSource;
  late MockAuthLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockAuthRemoteDataSource();
    mockLocalDataSource = MockAuthLocalDataSource();
    repository = AuthRepositoryImpl(
      mockRemoteDataSource,
      mockLocalDataSource,
    );
  });

  group('login', () {
    const tEmail = 'test@example.com';
    const tPassword = 'password123';
    final tUserModel = UserModel(id: '1', email: tEmail, name: 'Test User');
    final UserEntity tUserEntity = tUserModel; // UserModel is a subtype of UserEntity

    test(
      'should return user entity when the call to remote data source is successful',
      () async {
        // Arrange
        when(() => mockRemoteDataSource.login(email: any(named: 'email'), password: any(named: 'password')))
            .thenAnswer((_) async => tUserModel);

        // Act
        final result = await repository.login(email: tEmail, password: tPassword);

        // Assert
        verify(() => mockRemoteDataSource.login(email: tEmail, password: tPassword));
        expect(result, equals(Right(tUserEntity)));
        verifyNoMoreInteractions(mockRemoteDataSource);
        verifyZeroInteractions(mockLocalDataSource); // Assuming no local interaction on login
      },
    );

    test(
      'should return server failure when the call to remote data source is unsuccessful',
      () async {
        // Arrange
        when(() => mockRemoteDataSource.login(email: any(named: 'email'), password: any(named: 'password')))
            .thenThrow(ServerException(message: 'Invalid credentials', statusCode: 401));

        // Act
        final result = await repository.login(email: tEmail, password: tPassword);

        // Assert
        verify(() => mockRemoteDataSource.login(email: tEmail, password: tPassword));
        expect(result, isA<Left<Failure, UserEntity>>());
        result.fold(
          (failure) {
            expect(failure, isA<ServerFailure>());
            expect(failure.message, 'Invalid credentials');
            expect(failure.code, '401');
          },
          (r) => fail('should not have succeeded'),
        );
        verifyNoMoreInteractions(mockRemoteDataSource);
        verifyZeroInteractions(mockLocalDataSource);
      },
    );
  });
}
