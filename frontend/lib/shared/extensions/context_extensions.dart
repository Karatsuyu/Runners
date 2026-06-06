import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

/// Extensiones de BuildContext para acceder a Theme, MediaQuery y
/// mostrar SnackBars/Dialogs de forma concisa.
///
/// Uso:
/// ```dart
/// context.showSuccess('Pedido creado correctamente');
/// context.screenWidth
/// context.isDarkMode
/// ```
extension ContextExtensions on BuildContext {
  // ── Dimensiones de pantalla ───────────────────────────────────────────────
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  EdgeInsets get padding => MediaQuery.of(this).padding;
  EdgeInsets get viewInsets => MediaQuery.of(this).viewInsets;

  // ── Tema ──────────────────────────────────────────────────────────────────
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  // ── Navegación ────────────────────────────────────────────────────────────
  void pop<T>([T? result]) => Navigator.of(this).pop(result);
  bool get canPop => Navigator.of(this).canPop();

  // ── SnackBars ─────────────────────────────────────────────────────────────

  /// Muestra un SnackBar de éxito (verde).
  void showSuccess(String message, {Duration duration = const Duration(seconds: 3)}) {
    ScaffoldMessenger.of(this).hideCurrentSnackBar();
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.success,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  /// Muestra un SnackBar de error (rojo).
  void showError(String message, {Duration duration = const Duration(seconds: 4)}) {
    ScaffoldMessenger.of(this).hideCurrentSnackBar();
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.error,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  /// Muestra un SnackBar de advertencia (naranja).
  void showWarning(String message, {Duration duration = const Duration(seconds: 3)}) {
    ScaffoldMessenger.of(this).hideCurrentSnackBar();
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.warning_amber_outlined, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.warning,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  /// Muestra un SnackBar informativo (neutro).
  void showInfo(String message, {Duration duration = const Duration(seconds: 3)}) {
    ScaffoldMessenger.of(this).hideCurrentSnackBar();
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  // ── Teclado ───────────────────────────────────────────────────────────────
  void hideKeyboard() => FocusScope.of(this).unfocus();

  // ── Responsive helpers ────────────────────────────────────────────────────
  bool get isSmallScreen => screenWidth < 360;
  bool get isMediumScreen => screenWidth >= 360 && screenWidth < 600;
  bool get isLargeScreen => screenWidth >= 600;

  T responsive<T>({required T small, required T medium, T? large}) {
    if (isSmallScreen) return small;
    if (isLargeScreen && large != null) return large;
    return medium;
  }
}
