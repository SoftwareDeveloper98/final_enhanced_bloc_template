import 'package:get_it/get_it.dart';

// Function to configure dependencies for the Home feature
void configureHomeDependencies(GetIt sl) {
  // Register DataSources
  // sl.registerLazySingleton<HomeRemoteDataSource>(() => HomeRemoteDataSourceImpl(sl()));
  // sl.registerLazySingleton<HomeLocalDataSource>(() => HomeLocalDataSourceImpl(sl()));

  // Register Repositories
  // sl.registerLazySingleton<HomeRepository>(() => HomeRepositoryImpl(sl(), sl()));

  // Register UseCases
  // sl.registerFactory(() => GetFeaturedItemsUseCase(sl()));
  // sl.registerFactory(() => GetLatestNewsUseCase(sl()));

  // Register BLoCs / Cubits
  // sl.registerFactory(() => HomeBloc(
  //   getFeaturedItemsUseCase: sl(),
  //   getLatestNewsUseCase: sl(),
  // ));
  // sl.registerFactory(() => FeaturedItemsCubit(sl()));
  // sl.registerFactory(() => LatestNewsCubit(sl()));

  print("Home feature dependencies configured.");
}
