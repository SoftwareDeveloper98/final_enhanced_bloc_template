import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

import '../../../../core/common/error/exceptions.dart';
import '../../../../core/common/error/failures.dart';
import '../../domain/entities/item.dart';
import '../../domain/repositories/home_repository.dart'; // Correct import for interface
import '../datasources/home_local_datasource.dart';
import '../datasources/home_remote_datasource.dart';
import '../models/item_model.dart'; // Correct import for DTO

@LazySingleton(as: HomeRepository) // Register implementation with GetIt
class HomeRepositoryImpl implements HomeRepository {
  final HomeLocalDataSource localDataSource;
  final HomeRemoteDataSource remoteDataSource; // Inject remote data source
  final Logger logger; // Inject logger
  // final NetworkInfo networkInfo; // Assuming injection for connectivity check

  HomeRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.logger,
    // required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Item>>> getItems() async {
    // Example: Check network connectivity first if fetching from remote
    // if (await networkInfo.isConnected) {
    try {
      logger.i("Attempting to fetch items from remote data source...");
      final remoteItemModels = await remoteDataSource.getItems();
      logger.d("Fetched ${remoteItemModels.length} items from remote.");

      // Map DTOs to Domain Entities
      final items = remoteItemModels.map((model) => model.toEntity()).toList();

      // Cache the results (optional, depends on strategy)
      try {
        logger.i("Caching fetched items...");
        await localDataSource.cacheItems(items);
        logger.d("Items cached successfully.");
      } on CacheException catch (e) {
        logger.w("Failed to cache items: ${e.message}", error: e);
        // Decide if this should be a failure or just a warning
        // return Left(CacheFailure(message: "Failed to cache data: ${e.message}"));
      }

      return Right(items);

    } on DioException catch (e) {
      // Error should have been mapped by the interceptor
      logger.e("DioException caught in Repository", error: e, stackTrace: e.stackTrace);
      if (e.error is Exception) {
        // If interceptor mapped it to a custom exception, use that
        final mappedException = e.error as Exception;
        if (mappedException is ServerException) {
          return Left(ServerFailure(message: mappedException.message));
        } else if (mappedException is NetworkException) {
          return Left(NetworkFailure(message: mappedException.message));
        }
      }
      // Fallback if interceptor didn't map or mapping failed
      return Left(ServerFailure(message: e.message ?? "Network Error"));
    } on ServerException catch (e) {
      // Catch exceptions explicitly thrown by the remote data source
      logger.e("ServerException caught in Repository", error: e);
      return Left(ServerFailure(message: e.message));
    } on CacheException catch (e) {
      // Catch exceptions from the local data source (e.g., during caching)
      logger.e("CacheException caught in Repository", error: e);
      return Left(CacheFailure(message: e.message));
    } catch (e, stackTrace) {
      // Handle any other unexpected errors
      logger.f("Unexpected error caught in Repository", error: e, stackTrace: stackTrace);
      return Left(UnknownFailure(message: "An unexpected error occurred: ${e.toString()}"));
    }
    // } else {
    //   // --- Handle no network connection --- 
    //   logger.w("No network connection. Attempting to fetch from cache...");
    //   try {
    //     final localItems = await localDataSource.getLastItems();
    //     logger.d("Fetched ${localItems.length} items from cache while offline.");
    //     return Right(localItems);
    //   } on CacheException catch (e) {
    //     logger.e("CacheException caught while offline", error: e);
    //     return Left(CacheFailure(message: "Failed to load from cache: ${e.message}"));
    //   } catch (e, stackTrace) {
    //      logger.f("Unexpected error caught while offline", error: e, stackTrace: stackTrace);
    //      return Left(UnknownFailure(message: "An unexpected error occurred while offline: ${e.toString()}"));
    //   }
    // }
  }
}

