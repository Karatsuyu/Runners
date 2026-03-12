/// Validadores reutilizables para formularios de la app Runners.
/// Uso: `validator: AppValidators.email`
/// o    `validator: AppValidators.minLength(6)`
class AppValidators {
  AppValidators._();

  // ── Correo electrónico ────────────────────────────────────────────────────
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return 'El correo es obligatorio';
    final regex = RegExp(r'^[\w\-\.]+@([\w\-]+\.)+[\w]{2,}$');
    if (!regex.hasMatch(value.trim())) return 'Correo electrónico inválido';
    return null;
  }

  // ── Contraseña ────────────────────────────────────────────────────────────
  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'La contraseña es obligatoria';
    if (value.length < 6) return 'Mínimo 6 caracteres';
    return null;
  }

  /// Confirmar que dos contraseñas coinciden.
  /// Uso: `validator: AppValidators.confirmPassword(_passCtrl.text)`
  static String? Function(String?) confirmPassword(String original) {
    return (String? value) {
      if (value == null || value.isEmpty) return 'Confirma tu contraseña';
      if (value != original) return 'Las contraseñas no coinciden';
      return null;
    };
  }

  // ── Campos obligatorios ───────────────────────────────────────────────────
  static String? required(String? value) {
    if (value == null || value.trim().isEmpty) return 'Este campo es obligatorio';
    return null;
  }

  /// Campo obligatorio con etiqueta personalizada.
  /// Uso: `validator: AppValidators.requiredNamed('Nombre')`
  static String? Function(String?) requiredNamed(String fieldName) {
    return (String? value) {
      if (value == null || value.trim().isEmpty) return '$fieldName es obligatorio';
      return null;
    };
  }

  // ── Teléfono ──────────────────────────────────────────────────────────────
  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) return 'El teléfono es obligatorio';
    final cleaned = value.replaceAll(RegExp(r'[\s\-\+\(\)]'), '');
    if (cleaned.length < 7 || cleaned.length > 15) {
      return 'Número de teléfono inválido';
    }
    if (!RegExp(r'^\d+$').hasMatch(cleaned)) {
      return 'Solo se permiten números';
    }
    return null;
  }

  static String? phoneOptional(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    return phone(value);
  }

  // ── Longitud mínima ───────────────────────────────────────────────────────
  static String? Function(String?) minLength(int min) {
    return (String? value) {
      if (value == null || value.isEmpty) return 'Este campo es obligatorio';
      if (value.length < min) return 'Mínimo $min caracteres';
      return null;
    };
  }

  // ── Longitud máxima ───────────────────────────────────────────────────────
  static String? Function(String?) maxLength(int max) {
    return (String? value) {
      if (value != null && value.length > max) return 'Máximo $max caracteres';
      return null;
    };
  }

  // ── Número positivo (precios, montos) ─────────────────────────────────────
  static String? positiveNumber(String? value) {
    if (value == null || value.trim().isEmpty) return 'El valor es obligatorio';
    final cleaned = value.replaceAll(',', '.');
    final parsed = double.tryParse(cleaned);
    if (parsed == null) return 'Ingresa un número válido';
    if (parsed <= 0) return 'El valor debe ser mayor a 0';
    return null;
  }

  // ── Entero positivo ───────────────────────────────────────────────────────
  static String? positiveInt(String? value) {
    if (value == null || value.trim().isEmpty) return 'El valor es obligatorio';
    final parsed = int.tryParse(value.trim());
    if (parsed == null) return 'Ingresa un número entero válido';
    if (parsed <= 0) return 'El valor debe ser mayor a 0';
    return null;
  }

  // ── Nombre (letras y espacios) ────────────────────────────────────────────
  static String? name(String? value) {
    if (value == null || value.trim().isEmpty) return 'El nombre es obligatorio';
    if (value.trim().length < 2) return 'El nombre es demasiado corto';
    if (!RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚñÑüÜ\s]+$').hasMatch(value.trim())) {
      return 'Solo se permiten letras y espacios';
    }
    return null;
  }

  // ── URL opcional ──────────────────────────────────────────────────────────
  static String? urlOptional(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final regex = RegExp(r'^https?:\/\/.+\..+');
    if (!regex.hasMatch(value.trim())) return 'URL inválida (debe iniciar con http:// o https://)';
    return null;
  }

  // ── Descripción (mínimo y máximo) ─────────────────────────────────────────
  static String? description(String? value) {
    if (value == null || value.trim().isEmpty) return 'La descripción es obligatoria';
    if (value.trim().length < 10) return 'La descripción debe tener al menos 10 caracteres';
    if (value.trim().length > 500) return 'Máximo 500 caracteres';
    return null;
  }

  // ── Tamaño de archivo (bytes) ─────────────────────────────────────────────
  /// Valida que el tamaño del archivo no supere [maxBytes].
  /// Retorna un mensaje de error o null si es válido.
  static String? fileSize(int fileSizeBytes, {int maxBytes = 5 * 1024 * 1024}) {
    if (fileSizeBytes > maxBytes) {
      final maxMb = (maxBytes / (1024 * 1024)).toStringAsFixed(0);
      return 'El archivo supera el tamaño máximo de ${maxMb}MB';
    }
    return null;
  }
}
