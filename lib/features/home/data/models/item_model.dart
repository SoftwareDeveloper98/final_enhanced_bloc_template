import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/item.dart'; // Import domain entity

part 'item_model.freezed.dart';
part 'item_model.g.dart';

@freezed
class ItemModel with _$ItemModel {
  const ItemModel._(); // Private constructor for methods

  const factory ItemModel({
    required String id,
    required String name,
    // Add other fields that might exist in the API response but not the entity
    // String? apiSpecificField,
  }) = _ItemModel;

  factory ItemModel.fromJson(Map<String, dynamic> json) =>
      _$ItemModelFromJson(json);

  // Method to convert DTO to Domain Entity
  Item toEntity() {
    return Item(
      id: id,
      name: name,
    );
  }

  // Optional: Factory to create DTO from Domain Entity (if needed for sending data)
  // factory ItemModel.fromEntity(Item entity) {
  //   return ItemModel(
  //     id: entity.id,
  //     name: entity.name,
  //   );
  // }
}

