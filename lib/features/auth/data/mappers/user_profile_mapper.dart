import 'package:my_app/core/network/generated/openapi/lib/src/model/user_dto.dart';
import 'package:my_app/features/auth/domain/entities/user_profile.dart';

extension UserDtoToDomainMapper on UserDto {
  UserProfile toDomain() {
    if (userId == null || emailAddress == null || isActive == null) {
      // Consider a more robust error handling strategy, e.g., custom exceptions
      // or returning a Result type (e.g., Either<Failure, UserProfile>).
      // For this example, a simple exception is thrown.
      throw Exception('UserDto data is incomplete for mapping to UserProfile. Required fields: userId, emailAddress, isActive.');
    }
    return UserProfile(
      id: userId!,
      email: emailAddress!,
      name: fullName, // Mapping from fullName to name
      avatarUrl: avatarLink, // Mapping from avatarLink to avatarUrl
      isEmailVerified: false, // Example: DTO might not have this, set a default or get from elsewhere
      // lastLogin: This would typically be handled by the domain layer after user logs in,
      // or potentially from another data source if it's persisted.
      // It's unlikely to come directly from a generic UserDto for user creation/update.
    );
  }
}

extension UserProfileToDtoMapper on UserProfile {
  UserDto toDto() {
    return UserDto(
      userId: id,
      emailAddress: email,
      fullName: name,
      avatarLink: avatarUrl,
      // isActive could be determined by business logic, e.g.,
      // if the user profile is being sent for an update, it's implied they are active,
      // or this field might be managed by specific admin endpoints.
      // Defaulting to true for this example.
      isActive: true,
    );
  }
}
