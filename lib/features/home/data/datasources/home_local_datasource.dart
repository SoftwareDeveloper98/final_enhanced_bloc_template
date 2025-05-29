import 'package:injectable/injectable.dart';

import '../../domain/entities/item.dart';

// Abstract class for the data source
abstract class HomeLocalDataSource {
  Future<List<Item>> getItems();
}

// Mock implementation of the data source
@LazySingleton(as: HomeLocalDataSource)
class HomeLocalDataSourceImpl implements HomeLocalDataSource {
  @override
  Future<List<Item>> getItems() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Return mock data
    return List.generate(
      10,
      (index) => Item(
        id: index + 1,
        name: 'Item ${index + 1}',
        description: 'This is the description for item ${index + 1}.',
      ),
    );
  }
}

