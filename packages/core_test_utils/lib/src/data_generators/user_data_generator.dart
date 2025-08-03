// packages/core_test_utils/lib/src/data_generators/user_data_generator.dart
import 'package:my_app/features/auth/domain/entities/user_entity.dart'; // Adjust import path if needed

UserEntity createFakeUserEntity({
  String id = 'fake_id_123',
  String? email = 'fake@example.com',
  String? name = 'Fake User',
}) {
  return UserEntity(
    id: id,
    email: email,
    name: name,
  );
}
