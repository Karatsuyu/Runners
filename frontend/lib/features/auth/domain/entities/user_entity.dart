import 'package:equatable/equatable.dart';

enum UserRole { CLIENTE, PRESTADOR, DOMICILIARIO, ADMIN }

class UserEntity extends Equatable {
  final int id;
  final String email;
  final String? username;
  final String firstName;
  final String lastName;
  final String? phone;
  final String? profileImageUrl;
  final UserRole role;
  final DateTime dateJoined;

  const UserEntity({
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

  String get fullName => '$firstName $lastName'.trim();
  bool get isAdmin => role == UserRole.ADMIN;
  bool get isCliente => role == UserRole.CLIENTE;
  bool get isPrestador => role == UserRole.PRESTADOR;
  bool get isDomiciliario => role == UserRole.DOMICILIARIO;

  @override
  List<Object?> get props => [
    id,
    email,
    username,
    firstName,
    lastName,
    phone,
    profileImageUrl,
    role,
  ];
}
