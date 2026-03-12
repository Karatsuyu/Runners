/// Extensiones de String para la app Runners.
///
/// Uso:
/// ```dart
/// 'hola mundo'.capitalize        // → 'Hola Mundo'
/// 'CLIENTE'.toRoleLabel          // → 'Cliente'
/// 'DISPONIBLE'.toStatusLabel     // → 'Disponible'
/// '3133245678'.toFormattedPhone  // → '313 324 5678'
/// 'juan@mail.com'.isValidEmail   // → true
/// ```
extension StringExtensions on String {
  // ── Capitalización ────────────────────────────────────────────────────────

  /// Primera letra en mayúscula.
  String get capitalizeFirst {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  /// Cada palabra con primera letra en mayúscula.
  String get capitalize {
    if (isEmpty) return this;
    return split(' ').map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}').join(' ');
  }

  // ── Validaciones ──────────────────────────────────────────────────────────
  bool get isValidEmail {
    final regex = RegExp(r'^[\w\-\.]+@([\w\-]+\.)+[\w]{2,}$');
    return regex.hasMatch(trim());
  }

  bool get isValidPhone {
    final cleaned = replaceAll(RegExp(r'[\s\-\+\(\)]'), '');
    return cleaned.length >= 7 && cleaned.length <= 15 && RegExp(r'^\d+$').hasMatch(cleaned);
  }

  bool get isValidUrl {
    final regex = RegExp(r'^https?:\/\/.+\..+');
    return regex.hasMatch(trim());
  }

  bool get isNullOrEmpty => trim().isEmpty;
  bool get isNotNullOrEmpty => trim().isNotEmpty;

  // ── Roles de usuario ──────────────────────────────────────────────────────

  /// Convierte el rol del backend a etiqueta legible en español.
  String get toRoleLabel {
    switch (toUpperCase()) {
      case 'CLIENTE': return 'Cliente';
      case 'PRESTADOR': return 'Prestador de Servicios';
      case 'DOMICILIARIO': return 'Domiciliario';
      case 'ADMIN': return 'Administrador';
      default: return capitalizeFirst;
    }
  }

  /// Icono emoji del rol.
  String get toRoleEmoji {
    switch (toUpperCase()) {
      case 'CLIENTE': return '🛍️';
      case 'PRESTADOR': return '🔧';
      case 'DOMICILIARIO': return '🛵';
      case 'ADMIN': return '⚙️';
      default: return '👤';
    }
  }

  // ── Estados de servicios / domiciliarios ──────────────────────────────────

  /// Convierte un estado del backend a etiqueta legible.
  String get toStatusLabel {
    switch (toUpperCase()) {
      // Pedidos / entregas
      case 'PENDIENTE': return 'Pendiente';
      case 'CONFIRMADO': return 'Confirmado';
      case 'EN_PROCESO': return 'En proceso';
      case 'ENTREGADO': return 'Entregado';
      case 'CANCELADO': return 'Cancelado';
      // Prestadores / domiciliarios
      case 'DISPONIBLE': return 'Disponible';
      case 'OCUPADO': return 'Ocupado';
      case 'INACTIVO': return 'Inactivo';
      // Aprobación
      case 'APROBADO': return 'Aprobado';
      case 'RECHAZADO': return 'Rechazado';
      // Contactos
      case 'EN_SERVICIO': return 'En servicio';
      case 'FUERA_DE_SERVICIO': return 'Fuera de servicio';
      // Registros financieros
      case 'INGRESO': return 'Ingreso';
      case 'EGRESO': return 'Egreso';
      default: return capitalizeFirst;
    }
  }

  // ── Tipos de contacto ─────────────────────────────────────────────────────
  String get toContactTypeLabel {
    switch (toUpperCase()) {
      case 'EMERGENCIA': return 'Emergencia';
      case 'PROFESIONAL': return 'Profesional';
      case 'COMERCIO': return 'Comercio';
      case 'OTRO': return 'Otro';
      default: return capitalizeFirst;
    }
  }

  // ── Teléfono ──────────────────────────────────────────────────────────────

  /// Formatea un número de teléfono colombiano (10 dígitos → '313 324 5678').
  String get toFormattedPhone {
    final digits = replaceAll(RegExp(r'\D'), '');
    if (digits.length == 10) {
      return '${digits.substring(0, 3)} ${digits.substring(3, 6)} ${digits.substring(6)}';
    }
    return this;
  }

  // ── Truncado ──────────────────────────────────────────────────────────────

  /// Trunca el texto a [maxLength] caracteres y añade '...'.
  String truncate(int maxLength) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}...';
  }

  // ── Eliminación de espacios extra ─────────────────────────────────────────

  /// Elimina espacios dobles y recorta extremos.
  String get normalized => trim().replaceAll(RegExp(r'\s+'), ' ');

  // ── URI para llamadas y correos ───────────────────────────────────────────
  Uri get toTelUri => Uri(scheme: 'tel', path: trim());
  Uri get toMailUri => Uri(scheme: 'mailto', path: trim());
}

/// Extensión para String? (nullable).
extension NullableStringExtensions on String? {
  bool get isNullOrEmpty => this == null || this!.trim().isEmpty;
  bool get isNotNullOrEmpty => !isNullOrEmpty;
  String get orEmpty => this ?? '';
  String orDefault(String defaultValue) => isNullOrEmpty ? defaultValue : this!;
}
