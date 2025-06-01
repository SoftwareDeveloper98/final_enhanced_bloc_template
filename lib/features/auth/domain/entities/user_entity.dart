import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String? email;
  final String? name;
  // Add other relevant user properties like roles, avatarUrl, etc.

  const UserEntity({
    required this.id,
    this.email,
    this.name,
  });

  @override
  List<Object?> get props => [id, email, name];
}
