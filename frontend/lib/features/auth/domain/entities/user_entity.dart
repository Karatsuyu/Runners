import 'package:equatable/equatable.dart';

enum UserRole { CLIENTE, PRESTADOR, DOMICILIARIO, ADMIN }

class UserEntity extends Equatable {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String? phone;
  final UserRole role;
  final DateTime dateJoined;

  const UserEntity({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.phone,
    required this.role,
    required this.dateJoined,
  });

  String get fullName => '$firstName $lastName'.trim();
  bool get isAdmin => role == UserRole.ADMIN;
  bool get isCliente => role == UserRole.CLIENTE;
  bool get isPrestador => role == UserRole.PRESTADOR;
  bool get isDomiciliario => role == UserRole.DOMICILIARIO;

  @override
  List<Object?> get props => [id, email, role];
}
