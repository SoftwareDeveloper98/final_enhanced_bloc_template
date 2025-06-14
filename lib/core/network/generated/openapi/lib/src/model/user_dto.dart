// Placeholder: This file would normally be generated by openapi-generator
// based on an OpenAPI spec.
// For demonstration, we'll define a simple structure.

// import 'package:json_annotation/json_annotation.dart'; // Assume this would be used by generator

// part 'user_dto.g.dart'; // Assume generator creates this for json_serializable

// @JsonSerializable() // Assume generator adds this
class UserDto {
  final String? userId;
  final String? emailAddress;
  final bool? isActive;
  final String? fullName; // Different from domain model's 'name'
  final String? avatarLink; // Different from domain model's 'avatarUrl'

  UserDto({
    this.userId,
    this.emailAddress,
    this.isActive,
    this.fullName,
    this.avatarLink,
  });

  // factory UserDto.fromJson(Map<String, dynamic> json) => _$UserDtoFromJson(json); // Generated
  // Map<String, dynamic> toJson() => _$UserDtoToJson(this); // Generated

  // Manual fromJson for this placeholder:
  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      userId: json['userId'] as String?,
      emailAddress: json['emailAddress'] as String?,
      isActive: json['isActive'] as bool?,
      fullName: json['fullName'] as String?,
      avatarLink: json['avatarLink'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'emailAddress': emailAddress,
      'isActive': isActive,
      'fullName': fullName,
      'avatarLink': avatarLink,
    };
  }
}
