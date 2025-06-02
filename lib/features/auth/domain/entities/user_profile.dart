import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

// Indication that build_runner needs to be run:
// After defining this class, run:
// flutter pub run build_runner build --delete-conflicting-outputs

@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String id,
    required String email,
    String? name,
    String? avatarUrl,
    required bool isEmailVerified,
    DateTime? lastLogin,
  }) = _UserProfile;

  const UserProfile._(); // Private constructor for potential methods

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);

  // Example of a custom method if needed
  bool get hasProfileInfoCompleted => name != null && avatarUrl != null;
}
