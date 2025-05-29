import 'package:injectable/injectable.dart';

import '../models/item_model.dart'; // Import the DTO

abstract class HomeRemoteDataSource {
  /// Fetches items from the remote API.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<List<ItemModel>> getItems();
}

// Example implementation (Placeholder)
@LazySingleton(as: HomeRemoteDataSource)
class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  // final Dio dio; // Assuming Dio client is injected

  // HomeRemoteDataSourceImpl(this.dio);

  @override
  Future<List<ItemModel>> getItems() async {
    // TODO: Implement actual API call using Dio
    // Example:
    // try {
    //   final response = await dio.get('/items');
    //   if (response.statusCode == 200) {
    //     final List<dynamic> data = response.data as List<dynamic>;
    //     return data.map((json) => ItemModel.fromJson(json as Map<String, dynamic>)).toList();
    //   } else {
    //     throw ServerException(message: 'Failed to load items: ${response.statusCode}');
    //   }
    // } on DioException catch (e) {
    //   // DioException might already be mapped by interceptor, but handle specific cases if needed
    //   throw ServerException(message: e.message ?? 'Network error during fetch');
    // } catch (e) {
    //   throw ServerException(message: 'Unexpected error fetching items: $e');
    // }

    // Placeholder implementation:
    print('Simulating fetch from remote data source...');
    await Future.delayed(const Duration(seconds: 1));
    // Simulate success
    return [
      const ItemModel(id: 'remote_1', name: 'Remote Item 1'),
      const ItemModel(id: 'remote_2', name: 'Remote Item 2'),
    ];
    // Simulate error
    // throw ServerException(message: 'Simulated API error');
  }
}

