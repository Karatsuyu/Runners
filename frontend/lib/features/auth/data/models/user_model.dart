import '../../domain/entities/user_entity.dart';

class UserModel {
  final int id;
  final String email;
  final String? username;
  final String firstName;
  final String lastName;
  final String? phone;
  final String? profileImageUrl;
  final String role;
  final String dateJoined;

  UserModel({
    required this.id,
    required this.email,
    this.username,
    required this.firstName,
    required this.lastName,
    this.phone,
    this.profileImageUrl,
    required this.role,
    required this.dateJoined,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      email: json['email'] as String? ?? '',
      username: json['username'] as String?,
      firstName: json['first_name'] as String? ?? '',
      lastName: json['last_name'] as String? ?? '',
      phone: json['phone'] as String?,
      profileImageUrl: json['profile_image_url'] as String?,
      role: json['role'] as String? ?? 'CLIENTE',
      dateJoined: json['date_joined'] as String? ?? '',
    );
  }

  UserEntity toEntity() => UserEntity(
    id: id,
    email: email,
    username: username,
    firstName: firstName,
    lastName: lastName,
    phone: phone,
    profileImageUrl: profileImageUrl,
    role: UserRole.values.firstWhere(
      (r) => r.name == role,
      orElse: () => UserRole.CLIENTE,
    ),
    dateJoined: DateTime.tryParse(dateJoined) ?? DateTime.now(),
  );
}
