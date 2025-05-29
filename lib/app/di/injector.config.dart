// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:hive_flutter/hive_flutter.dart' as _i986;
import 'package:injectable/injectable.dart' as _i526;
import 'package:logger/logger.dart' as _i974;

import '../../core/common/logging/logging_module.dart' as _i841;
import '../../core/infrastructure/network/dio_client.dart' as _i399;
import '../../core/infrastructure/storage/hive_service.dart' as _i994;
import '../../core/infrastructure/theme/theme_cubit.dart' as _i484;
import '../../features/home/data/datasources/home_local_datasource.dart'
    as _i314;
import '../../features/home/data/datasources/home_remote_datasource.dart'
    as _i278;
import '../../features/home/data/repositories/home_repository_impl.dart'
    as _i76;
import '../../features/home/domain/repositories/home_repository.dart' as _i0;
import '../../features/home/domain/usecases/get_items.dart' as _i520;
import '../../features/home/presentation/bloc/home_bloc.dart' as _i202;

const String _dev = 'dev';
const String _prod = 'prod';

// initializes the registration of main-scope dependencies inside of GetIt
Future<_i174.GetIt> $initGetIt(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) async {
  final gh = _i526.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  final storageModule = _$StorageModule();
  final networkModule = _$NetworkModule();
  final loggingModule = _$LoggingModule();
  await gh.singletonAsync<_i986.HiveInterface>(
    () => storageModule.hive(),
    preResolve: true,
  );
  gh.lazySingleton<_i484.ThemeCubit>(() => _i484.ThemeCubit());
  gh.factory<String>(
    () => networkModule.devBaseUrl,
    instanceName: 'BaseUrl',
    registerFor: {_dev},
  );
  gh.lazySingleton<_i278.HomeRemoteDataSource>(
      () => _i278.HomeRemoteDataSourceImpl());
  gh.lazySingleton<_i314.HomeLocalDataSource>(
      () => _i314.HomeLocalDataSourceImpl());
  gh.factory<_i841.AppLogFilter>(
    () => _i841.DevLogFilter(),
    registerFor: {_dev},
  );
  await gh.lazySingletonAsync<_i986.Box<dynamic>>(
    () => storageModule.settingsBox(gh<_i986.HiveInterface>()),
    preResolve: true,
  );
  gh.factory<String>(
    () => networkModule.prodBaseUrl,
    instanceName: 'BaseUrl',
    registerFor: {_prod},
  );
  gh.factory<_i841.AppLogFilter>(
    () => _i841.ProdLogFilter(),
    registerFor: {_prod},
  );
  gh.lazySingleton<_i974.Logger>(
      () => loggingModule.logger(gh<_i841.AppLogFilter>()));
  gh.lazySingleton<_i994.CacheManager>(() =>
      _i994.CacheManager(gh<_i986.Box<dynamic>>(instanceName: 'settingsBox')));
  gh.lazySingleton<_i0.HomeRepository>(() => _i76.HomeRepositoryImpl(
        localDataSource: gh<_i314.HomeLocalDataSource>(),
        remoteDataSource: gh<_i278.HomeRemoteDataSource>(),
        logger: gh<_i974.Logger>(),
      ));
  gh.lazySingleton<_i361.Dio>(() => networkModule.dio(
        gh<String>(instanceName: 'BaseUrl'),
        gh<_i974.Logger>(),
      ));
  gh.lazySingleton<_i520.GetItems>(
      () => _i520.GetItems(gh<_i0.HomeRepository>()));
  gh.factory<_i202.HomeBloc>(() => _i202.HomeBloc(gh<_i520.GetItems>()));
  return getIt;
}

class _$StorageModule extends _i994.StorageModule {}

class _$NetworkModule extends _i399.NetworkModule {}

class _$LoggingModule extends _i841.LoggingModule {}
