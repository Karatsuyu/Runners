import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/router/app_routes.dart';

/// Pantalla de confirmación exitosa de un pedido.
/// Se navega a esta pantalla después de que el pedido fue creado en el backend.
///
/// Recibe el ID del pedido y el total vía [extra] de GoRouter:
/// ```dart
/// context.go(AppRoutes.orderConfirm, extra: {'orderId': 42, 'total': 35000.0, 'commerceName': 'Panadería El Sol'});
/// ```
class OrderConfirmScreen extends ConsumerWidget {
  final int? orderId;
  final double? total;
  final String? commerceName;

  const OrderConfirmScreen({
    super.key,
    this.orderId,
    this.total,
    this.commerceName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currency = NumberFormat.simpleCurrency(locale: 'es_CO', name: 'COP');

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Ícono de éxito animado ─────────────────────────────────
              const _SuccessIcon(),

              const SizedBox(height: 32),

              // ── Título ────────────────────────────────────────────────
              const Text(
                '¡Pedido confirmado!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Tu pedido fue enviado correctamente.\nEn breve lo estaremos procesando.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 32),

              // ── Tarjeta de resumen ────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withAlpha(15),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.primaryGreen.withAlpha(50),
                  ),
                ),
                child: Column(
                  children: [
                    if (orderId != null)
                      _SummaryRow(
                        icon: Icons.receipt_rounded,
                        label: 'Número de pedido',
                        value: '#$orderId',
                        valueStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColors.primaryGreen,
                        ),
                      ),
                    if (commerceName != null) ...[
                      const Divider(height: 20),
                      _SummaryRow(
                        icon: Icons.store_rounded,
                        label: 'Comercio',
                        value: commerceName!,
                      ),
                    ],
                    if (total != null) ...[
                      const Divider(height: 20),
                      _SummaryRow(
                        icon: Icons.payments_rounded,
                        label: 'Total',
                        value: currency.format(total),
                        valueStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                    const Divider(height: 20),
                    _SummaryRow(
                      icon: Icons.schedule_rounded,
                      label: 'Estado',
                      value: 'Pendiente de confirmación',
                      valueStyle: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.statusPending,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ── Nota informativa ─────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue.shade600, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'El comercio confirmará tu pedido y te avisará cuando esté listo.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue.shade700,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // ── Botones de acción ────────────────────────────────────
              ElevatedButton.icon(
                icon: const Icon(Icons.receipt_long_rounded),
                label: const Text('Ver mis pedidos'),
                onPressed: () => context.go(AppRoutes.orderHistory),
              ),

              const SizedBox(height: 12),

              OutlinedButton.icon(
                icon: const Icon(Icons.store_rounded),
                label: const Text('Seguir comprando'),
                onPressed: () => context.go(AppRoutes.store),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.primaryGreen),
                  foregroundColor: AppColors.primaryGreen,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Widget privado: ícono animado de éxito ──────────────────────────────────
class _SuccessIcon extends StatefulWidget {
  const _SuccessIcon();

  @override
  State<_SuccessIcon> createState() => _SuccessIconState();
}

class _SuccessIconState extends State<_SuccessIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scale = CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: Container(
        width: 100,
        height: 100,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.success.withAlpha(20),
          shape: BoxShape.circle,
        ),
        child: Container(
          width: 80,
          height: 80,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: AppColors.success,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check_rounded,
            color: Colors.white,
            size: 44,
          ),
        ),
      ),
    );
  }
}

// ── Widget privado: fila de resumen ─────────────────────────────────────────
class _SummaryRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final TextStyle? valueStyle;

  const _SummaryRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: valueStyle ??
                const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: AppColors.textPrimary,
                ),
          ),
        ),
      ],
    );
  }
}
