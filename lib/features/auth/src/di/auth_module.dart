import 'package:get_it/get_it.dart';

// Function to configure dependencies for the Authentication feature
void configureAuthDependencies(GetIt sl) {
  // Register DataSources
  // sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(sl()));
  // sl.registerLazySingleton<AuthLocalDataSource>(() => AuthLocalDataSourceImpl(sl()));

  // Register Repositories
  // sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl(), sl()));

  // Register UseCases
  // sl.registerFactory(() => LoginUserUseCase(sl()));
  // sl.registerFactory(() => RegisterUserUseCase(sl()));
  // sl.registerFactory(() => LogoutUserUseCase(sl()));
  // sl.registerFactory(() => GetCurrentUserUseCase(sl()));

  // Register BLoCs / Cubits
  // sl.registerFactory(() => AuthBloc(
  //   loginUserUseCase: sl(),
  //   registerUserUseCase: sl(),
  //   logoutUserUseCase: sl(),
  //   getCurrentUserUseCase: sl(),
  // ));

  print("Auth feature dependencies configured.");
}
