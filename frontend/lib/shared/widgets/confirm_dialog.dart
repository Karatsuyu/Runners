import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

/// Diálogo de confirmación reutilizable para la app Runners.
///
/// Uso básico:
/// ```dart
/// final confirmed = await ConfirmDialog.show(
///   context: context,
///   title: '¿Eliminar contacto?',
///   message: 'Esta acción no se puede deshacer.',
/// );
/// if (confirmed == true) { ... }
/// ```
///
/// Uso destructivo (botón rojo):
/// ```dart
/// final confirmed = await ConfirmDialog.show(
///   context: context,
///   title: 'Cancelar pedido',
///   message: '¿Seguro que deseas cancelar el pedido #123?',
///   confirmLabel: 'Sí, cancelar',
///   isDestructive: true,
/// );
/// ```
class ConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;
  final bool isDestructive;
  final IconData? icon;

  const ConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmLabel = 'Confirmar',
    this.cancelLabel = 'Cancelar',
    this.isDestructive = false,
    this.icon,
  });

  /// Muestra el diálogo y devuelve `true` si el usuario confirmó, `false`/`null` si canceló.
  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String message,
    String confirmLabel = 'Confirmar',
    String cancelLabel = 'Cancelar',
    bool isDestructive = false,
    IconData? icon,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => ConfirmDialog(
        title: title,
        message: message,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        isDestructive: isDestructive,
        icon: icon,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final confirmColor = isDestructive ? AppColors.error : AppColors.primaryGreen;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      title: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: isDestructive ? AppColors.error : AppColors.primaryGreen, size: 24),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      content: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        child: Text(
          message,
          style: const TextStyle(fontSize: 14, color: AppColors.textSecondary, height: 1.5),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            cancelLabel,
            style: const TextStyle(color: AppColors.textSecondary),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: confirmColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(confirmLabel),
        ),
        const SizedBox(width: 4),
      ],
    );
  }
}

/// Variante de diálogo de información (solo botón OK).
///
/// Uso:
/// ```dart
/// await InfoDialog.show(
///   context: context,
///   title: 'Pedido creado',
///   message: 'Tu pedido fue enviado correctamente.',
///   icon: Icons.check_circle_outline,
/// );
/// ```
class InfoDialog extends StatelessWidget {
  final String title;
  final String message;
  final String buttonLabel;
  final IconData? icon;
  final Color? iconColor;

  const InfoDialog({
    super.key,
    required this.title,
    required this.message,
    this.buttonLabel = 'Entendido',
    this.icon,
    this.iconColor,
  });

  static Future<void> show({
    required BuildContext context,
    required String title,
    required String message,
    String buttonLabel = 'Entendido',
    IconData? icon,
    Color? iconColor,
  }) {
    return showDialog<void>(
      context: context,
      builder: (_) => InfoDialog(
        title: title,
        message: message,
        buttonLabel: buttonLabel,
        icon: icon,
        iconColor: iconColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            const SizedBox(height: 8),
            Icon(icon, size: 56, color: iconColor ?? AppColors.primaryGreen),
            const SizedBox(height: 16),
          ],
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, color: AppColors.textSecondary, height: 1.5),
          ),
          const SizedBox(height: 16),
        ],
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryGreen,
            foregroundColor: Colors.white,
            minimumSize: const Size(120, 44),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: () => Navigator.of(context).pop(),
          child: Text(buttonLabel),
        ),
      ],
    );
  }
}
