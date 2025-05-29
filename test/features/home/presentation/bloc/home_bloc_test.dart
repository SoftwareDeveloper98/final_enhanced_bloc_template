import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:clean_bloc_template/core/common/error/failures.dart';
import 'package:clean_bloc_template/core/common/usecases/usecase.dart';
import 'package:clean_bloc_template/features/home/domain/entities/item.dart';
import 'package:clean_bloc_template/features/home/domain/usecases/get_items.dart';
import 'package:clean_bloc_template/features/home/presentation/bloc/home_bloc.dart';
import 'package:clean_bloc_template/features/home/presentation/bloc/home_event.dart';
import 'package:clean_bloc_template/features/home/presentation/bloc/home_state.dart';

// Generate mocks for GetItems use case
@GenerateMocks([GetItems])
import 'home_bloc_test.mocks.dart';

void main() {
  late HomeBloc homeBloc;
  late MockGetItems mockGetItems;

  setUp(() {
    mockGetItems = MockGetItems();
    // Note: In a real app with DI, you might test the Bloc obtained from GetIt
    // or manually inject the mock use case like this.
    homeBloc = HomeBloc(mockGetItems);
  });

  tearDown(() {
    homeBloc.close();
  });

  final tItems = [const Item(id: '1', name: 'Test Item 1')];
  const tServerFailure = ServerFailure(message: 'Server Error');
  const tCacheFailure = CacheFailure(message: 'Cache Error');

  test('initial state should be HomeInitial', () {
    expect(homeBloc.state, HomeInitial());
  });

  group('LoadItems Event', () {
    blocTest<HomeBloc, HomeState>(
      'emits [HomeLoading, HomeLoaded] when GetItems returns data successfully',
      build: () {
        // Arrange: Stub the use case to return Right(tItems)
        when(mockGetItems(any)).thenAnswer((_) async => Right(tItems));
        return homeBloc;
      },
      act: (bloc) => bloc.add(LoadItems()),
      expect: () => <HomeState>[
        HomeLoading(),
        HomeLoaded(tItems),
      ],
      verify: (_) {
        // Verify that the use case was called with NoParams
        verify(mockGetItems(NoParams()));
      },
    );

    blocTest<HomeBloc, HomeState>(
      'emits [HomeLoading, HomeError] when GetItems returns a ServerFailure',
      build: () {
        // Arrange: Stub the use case to return Left(tServerFailure)
        when(mockGetItems(any)).thenAnswer((_) async => const Left(tServerFailure));
        return homeBloc;
      },
      act: (bloc) => bloc.add(LoadItems()),
      expect: () => <HomeState>[
        HomeLoading(),
        // Check the error message mapping in the Bloc
        const HomeError('Server Error: Server Error'), 
      ],
      verify: (_) {
        // Verify that the use case was called with NoParams
        verify(mockGetItems(NoParams()));
      },
    );

    blocTest<HomeBloc, HomeState>(
      'emits [HomeLoading, HomeError] when GetItems returns a CacheFailure',
      build: () {
        // Arrange: Stub the use case to return Left(tCacheFailure)
        when(mockGetItems(any)).thenAnswer((_) async => const Left(tCacheFailure));
        return homeBloc;
      },
      act: (bloc) => bloc.add(LoadItems()),
      expect: () => <HomeState>[
        HomeLoading(),
        const HomeError('Cache Error: Cache Error'),
      ],
      verify: (_) {
        verify(mockGetItems(NoParams()));
      },
    );

    // Testing bloc_concurrency behavior
    blocTest<HomeBloc, HomeState>(
      'drops subsequent LoadItems events while processing the first one (droppable)',
      build: () {
        // Simulate a slow response
        when(mockGetItems(any)).thenAnswer((_) async {
          await Future.delayed(const Duration(milliseconds: 100));
          return Right(tItems);
        });
        return homeBloc;
      },
      act: (bloc) {
        // Add multiple LoadItems events in quick succession
        bloc.add(LoadItems());
        bloc.add(LoadItems()); // This should be dropped
        bloc.add(LoadItems()); // This should be dropped
      },
      wait: const Duration(milliseconds: 200),
      expect: () => <HomeState>[
        HomeLoading(),
        HomeLoaded(tItems),
      ],
      verify: (_) {
        // Verify that the use case was called only once despite multiple events
        verify(mockGetItems(NoParams())).called(1);
      },
    );
  });

  group('RefreshItems Event', () {
    blocTest<HomeBloc, HomeState>(
      'emits [HomeLoading, HomeLoaded] when RefreshItems is successful',
      build: () {
        when(mockGetItems(any)).thenAnswer((_) async => Right(tItems));
        return homeBloc;
      },
      seed: () => HomeLoaded([]), // Start with an already loaded state
      act: (bloc) => bloc.add(RefreshItems()),
      expect: () => <HomeState>[
        HomeLoading(),
        HomeLoaded(tItems),
      ],
    );
  });
}
