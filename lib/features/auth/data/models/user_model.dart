import '../../domain/entities/user_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart'; // For json_serializable

@JsonSerializable()
class UserModel extends UserEntity {
  // UserModel might have additional properties or methods specific to data layer
  // e.g., fromJson, toJson, or fields not present in UserEntity if needed.

  const UserModel({
    required super.id,
    super.email,
    super.name,
    // Add other properties that might come from API but not in UserEntity
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  // Example: Convert UserModel to UserEntity (often they are compatible directly)
  UserEntity toEntity() => UserEntity(id: id, email: email, name: name);
}
