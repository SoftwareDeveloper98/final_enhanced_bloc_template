import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:clean_bloc_template/core/common/error/failures.dart';
import 'package:clean_bloc_template/core/common/usecases/usecase.dart';
import 'package:clean_bloc_template/features/home/domain/entities/item.dart';
import 'package:clean_bloc_template/features/home/domain/repositories/home_repository.dart';
import 'package:clean_bloc_template/features/home/domain/usecases/get_items.dart';

// Generate mocks for HomeRepository
@GenerateMocks([HomeRepository])
import 'get_items_test.mocks.dart';

void main() {
  late GetItems usecase;
  late MockHomeRepository mockHomeRepository;

  setUp(() {
    mockHomeRepository = MockHomeRepository();
    usecase = GetItems(mockHomeRepository);
  });

  final tItems = [const Item(id: '1', name: 'Test Item 1')];

  group('GetItems', () {
    test('should get items from the repository when successful', () async {
      // Arrange
      // Stub the repository method to return a Right with the test items
      when(mockHomeRepository.getItems()).thenAnswer((_) async => Right(tItems));

      // Act
      // Execute the use case
      final result = await usecase(NoParams());

      // Assert
      // Expect the result to be a Right containing the test items
      expect(result, Right(tItems));
      // Verify that the getItems method was called exactly once
      verify(mockHomeRepository.getItems());
      // Ensure no other interactions happened with the mock repository
      verifyNoMoreInteractions(mockHomeRepository);
    });

    test('should return a ServerFailure when repository fails', () async {
      // Arrange
      final failure = ServerFailure(message: 'Server error');
      when(mockHomeRepository.getItems()).thenAnswer((_) async => Left(failure));

      // Act
      final result = await usecase(NoParams());

      // Assert
      expect(result, Left(failure));
      verify(mockHomeRepository.getItems());
      verifyNoMoreInteractions(mockHomeRepository);
    });

    test('should return a CacheFailure when local data source fails', () async {
      // Arrange
      final failure = CacheFailure(message: 'Cache error');
      when(mockHomeRepository.getItems()).thenAnswer((_) async => Left(failure));

      // Act
      final result = await usecase(NoParams());

      // Assert
      expect(result, Left(failure));
      verify(mockHomeRepository.getItems());
      verifyNoMoreInteractions(mockHomeRepository);
    });
  });
}
