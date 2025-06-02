// packages/core_test_utils/lib/src/data_generators/user_data_generator.dart
import 'package:my_app/features/auth/domain/entities/user_profile.dart'; // Adjust import path if needed

UserProfile createFakeUserProfile({
  String id = 'fake_id_123',
  String email = 'fake@example.com',
  String? name = 'Fake User',
  String? avatarUrl,
  bool isEmailVerified = true,
  DateTime? lastLogin,
}) {
  return UserProfile(
    id: id,
    email: email,
    name: name,
    avatarUrl: avatarUrl,
    isEmailVerified: isEmailVerified,
    lastLogin: lastLogin ?? DateTime.now().subtract(Duration(days: 1)),
  );
}
