import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../providers/store_provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/router/app_routes.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);
    final isGuest = ref.watch(authProvider).isGuest;
    final currency = NumberFormat.simpleCurrency(locale: 'es_CO', name: 'COP');

    double total = cart.fold(0.0, (p, e) => p + e.subtotal);

    return Scaffold(
      appBar: AppBar(title: const Text('Carrito')),
      body: cart.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('Tu carrito está vacío'),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => context.go(AppRoutes.store),
                    child: const Text('Seguir comprando'),
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      itemCount: cart.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (_, i) {
                        final item = cart[i];
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                CircleAvatar(radius: 24, backgroundColor: AppColors.primaryGreen.withAlpha(20), child: const Icon(Icons.fastfood_rounded, color: AppColors.primaryGreen)),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(item.productName, style: const TextStyle(fontWeight: FontWeight.w600)),
                                      const SizedBox(height: 6),
                                      Text(currency.format(item.unitPrice), style: const TextStyle(color: AppColors.textSecondary)),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(icon: const Icon(Icons.remove_circle_outline), onPressed: () => cartNotifier.decreaseQuantity(item.productId)),
                                    Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.bold)),
                                    IconButton(icon: const Icon(Icons.add_circle_outline), onPressed: () => cartNotifier.addItem(OrderItemInput(productId: item.productId, productName: item.productName, unitPrice: item.unitPrice, quantity: 1), cartNotifier.currentCommerceId ?? 0)),
                                  ],
                                ),
                                IconButton(icon: const Icon(Icons.delete_outline), onPressed: () => cartNotifier.removeItem(item.productId)),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                      Text(currency.format(total), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.primaryGreen)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            if (isGuest) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Debes iniciar sesión para pagar.')));
                              context.go(AppRoutes.login);
                              return;
                            }

                            final payload = ref.read(cartProvider.notifier).toOrderPayload();
                            try {
                              final order = await ref.read(storeDataSourceProvider).createOrder(payload);
                              // Clear cart and navigate to confirmation
                              ref.read(cartProvider.notifier).clearCart();
                              context.go(AppRoutes.orderConfirm, extra: {'orderId': order.id, 'total': order.total, 'commerceName': order.commerceName});
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error al crear el pedido')));
                            }
                          },
                          child: const Text('Pagar ahora'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
