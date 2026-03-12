class ServerException implements Exception {
  final String message;
  final int? statusCode;
  ServerException({required this.message, this.statusCode});
  @override
  String toString() => message;
}

class NetworkException implements Exception {
  final String message;
  NetworkException({this.message = 'Sin conexión a internet. Verifica tu red.'});
  @override
  String toString() => message;
}

class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException({this.message = 'Sesión expirada. Inicia sesión nuevamente.'});
  @override
  String toString() => message;
}

class ValidationException implements Exception {
  final Map<String, dynamic> errors;
  ValidationException({required this.errors});

  String get firstError {
    if (errors.isEmpty) return 'Error de validación';
    final firstKey = errors.keys.first;
    final value = errors[firstKey];
    if (value is List) return value.first.toString();
    return value.toString();
  }

  @override
  String toString() => firstError;
}
