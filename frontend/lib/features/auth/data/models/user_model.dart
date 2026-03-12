import '../../domain/entities/user_entity.dart';

class UserModel {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String? phone;
  final String role;
  final String dateJoined;

  UserModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.phone,
    required this.role,
    required this.dateJoined,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      email: json['email'] as String? ?? '',
      firstName: json['first_name'] as String? ?? '',
      lastName: json['last_name'] as String? ?? '',
      phone: json['phone'] as String?,
      role: json['role'] as String? ?? 'CLIENTE',
      dateJoined: json['date_joined'] as String? ?? '',
    );
  }

  UserEntity toEntity() => UserEntity(
        id: id,
        email: email,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        role: UserRole.values.firstWhere(
          (r) => r.name == role,
          orElse: () => UserRole.CLIENTE,
        ),
        dateJoined: DateTime.tryParse(dateJoined) ?? DateTime.now(),
      );
}
