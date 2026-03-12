import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../providers/store_provider.dart';
import '../../../../shared/widgets/app_loading.dart';
import '../../../../shared/widgets/app_error_widget.dart';
import '../../../../shared/widgets/app_empty_state.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/router/app_routes.dart';

class StoreScreen extends ConsumerWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final commercesAsync = ref.watch(commercesProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final cart = ref.watch(cartProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tienda Runners'),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                onPressed: () => context.go('/client/cart'),
              ),
              if (cart.isNotEmpty)
                Positioned(
                  right: 6,
                  top: 6,
                  child: CircleAvatar(
                    radius: 9,
                    backgroundColor: Colors.red,
                    child: Text(
                      '${cart.length}',
                      style: const TextStyle(
                          color: Colors.white, fontSize: 10),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Chips de categorías
          categoriesAsync.when(
            loading: () => const SizedBox(
                height: 56,
                child: Center(child: AppLoading(size: 24))),
            error: (_, __) => const SizedBox(),
            data: (categories) => SizedBox(
              height: 56,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 8),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: const Text('Todos'),
                      selected: selectedCategory == null,
                      selectedColor:
                          AppColors.primaryGreen.withAlpha(30),
                      onSelected: (_) => ref
                          .read(selectedCategoryProvider.notifier)
                          .state = null,
                    ),
                  ),
                  ...categories.map(
                    (cat) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(cat.name),
                        selected: selectedCategory == cat.id,
                        selectedColor:
                            AppColors.primaryGreen.withAlpha(30),
                        onSelected: (_) => ref
                            .read(selectedCategoryProvider.notifier)
                            .state = cat.id,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Lista de comercios
          Expanded(
            child: commercesAsync.when(
              loading: () => const AppLoading(),
              error: (err, _) => AppErrorWidget(
                message: 'Error al cargar comercios',
                onRetry: () => ref.invalidate(commercesProvider),
              ),
              data: (commerces) => commerces.isEmpty
                  ? const AppEmptyState(
                      icon: Icons.store_mall_directory_outlined,
                      title: 'Sin establecimientos',
                      subtitle:
                          'No hay comercios disponibles en esta categoría.',
                    )
                  : RefreshIndicator(
                      onRefresh: () async =>
                          ref.invalidate(commercesProvider),
                      child: ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: commerces.length,
                        itemBuilder: (_, i) {
                          final c = commerces[i];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor:
                                    AppColors.primaryGreen.withAlpha(20),
                                child: const Icon(
                                    Icons.store_rounded,
                                    color: AppColors.primaryGreen),
                              ),
                              title: Text(c.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600)),
                              subtitle: Text(c.description,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis),
                              trailing: const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 16),
                              onTap: () =>
                                  context.go('/client/store/${c.id}'),
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primaryGreen,
        onPressed: () => context.go('/client/orders'),
        icon: const Icon(Icons.history, color: Colors.white),
        label: const Text('Mis Pedidos',
            style: TextStyle(color: Colors.white)),
      ),
    );
  }
}

// ── Commerce Detail ──────────────────────────────────────────────────────
class CommerceDetailScreen extends ConsumerWidget {
  final int commerceId;
  const CommerceDetailScreen({super.key, required this.commerceId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(commerceProductsProvider(commerceId));
    final cart = ref.watch(cartProvider);
    final currency =
        NumberFormat.simpleCurrency(locale: 'es_CO', name: 'COP');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Menú / Catálogo'),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                onPressed: () => context.go('/client/cart'),
              ),
              if (cart.isNotEmpty)
                Positioned(
                  right: 6,
                  top: 6,
                  child: CircleAvatar(
                    radius: 9,
                    backgroundColor: Colors.red,
                    child: Text('${cart.length}',
                        style: const TextStyle(
                            color: Colors.white, fontSize: 10)),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: productsAsync.when(
        loading: () => const AppLoading(),
        error: (e, _) => AppErrorWidget(
          message: 'Error al cargar productos',
          onRetry: () =>
              ref.invalidate(commerceProductsProvider(commerceId)),
        ),
        data: (products) => products.isEmpty
            ? const AppEmptyState(
                icon: Icons.inventory_2_outlined,
                title: 'Sin productos',
                subtitle: 'Este comercio aún no tiene productos registrados.',
              )
            : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: products.length,
                itemBuilder: (_, i) {
                  final p = products[i];
                  final inCart =
                      cart.indexWhere((c) => c.productId == p.id);
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundColor:
                                AppColors.primaryGreen.withAlpha(15),
                            child: const Icon(Icons.fastfood_rounded,
                                color: AppColors.primaryGreen),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(p.name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600)),
                                if (p.description.isNotEmpty)
                                  Text(p.description,
                                      style: const TextStyle(
                                          color: AppColors.textSecondary,
                                          fontSize: 12),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis),
                                Text(
                                  currency.format(p.price),
                                  style: const TextStyle(
                                    color: AppColors.primaryGreen,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (!p.isAvailable)
                            const Text('No disponible',
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 11))
                          else if (inCart >= 0)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_circle,
                                      color: AppColors.error),
                                  onPressed: () => ref
                                      .read(cartProvider.notifier)
                                      .decreaseQuantity(p.id),
                                ),
                                Text('${cart[inCart].quantity}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                IconButton(
                                  icon: const Icon(Icons.add_circle,
                                      color: AppColors.primaryGreen),
                                  onPressed: () => ref
                                      .read(cartProvider.notifier)
                                      .addItem(
                                        OrderItemInput(
                                          productId: p.id,
                                          productName: p.name,
                                          unitPrice: p.price,
                                          quantity: 1,
                                        ),
                                        commerceId,
                                      ),
                                ),
                              ],
                            )
                          else
                            ElevatedButton(
                              onPressed: () => ref
                                  .read(cartProvider.notifier)
                                  .addItem(
                                    OrderItemInput(
                                      productId: p.id,
                                      productName: p.name,
                                      unitPrice: p.price,
                                      quantity: 1,
                                    ),
                                    commerceId,
                                  ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryGreen,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                minimumSize: Size.zero,
                              ),
                              child: const Text('+',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18)),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

// ── Cart Screen ──────────────────────────────────────────────────────────
class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});
  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  bool _loading = false;
  String? _error;

  Future<void> _confirmOrder() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final cartNotifier = ref.read(cartProvider.notifier);
      final payload = cartNotifier.toOrderPayload();
      final order = await ref.read(storeDataSourceProvider).createOrder(payload);
      final total = cartNotifier.total;
      ref.read(cartProvider.notifier).clearCart();
      if (mounted) {
        context.go(
          AppRoutes.orderConfirm,
          extra: {
            'orderId': order.id,
            'total': total,
            'commerceName': order.commerceName,
          },
        );
      }
    } catch (e) {
      setState(() => _error = 'Error al confirmar el pedido: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);
    final currency =
        NumberFormat.simpleCurrency(locale: 'es_CO', name: 'COP');
    final total = ref.read(cartProvider.notifier).total;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Carrito'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/client/store'),
        ),
      ),
      body: cart.isEmpty
          ? const AppEmptyState(
              icon: Icons.shopping_cart_outlined,
              title: 'Carrito vacío',
              subtitle: 'Agrega productos desde la tienda.',
            )
          : Column(
              children: [
                if (_error != null)
                  Container(
                    color: Colors.red.shade50,
                    padding: const EdgeInsets.all(12),
                    child: Text(_error!,
                        style: const TextStyle(color: AppColors.error)),
                  ),
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.length,
                    itemBuilder: (_, i) {
                      final item = cart[i];
                      return ListTile(
                        title: Text(item.productName),
                        subtitle:
                            Text(currency.format(item.unitPrice)),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle,
                                  color: AppColors.error),
                              onPressed: () => ref
                                  .read(cartProvider.notifier)
                                  .removeItem(item.productId),
                            ),
                            Text('${item.quantity}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            IconButton(
                              icon: const Icon(Icons.add_circle,
                                  color: AppColors.primaryGreen),
                              onPressed: () => ref
                                  .read(cartProvider.notifier)
                                  .addItem(
                                    OrderItemInput(
                                      productId: item.productId,
                                      productName: item.productName,
                                      unitPrice: item.unitPrice,
                                      quantity: 1,
                                    ),
                                    ref
                                            .read(cartProvider.notifier)
                                            .currentCommerceId ??
                                        0,
                                  ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withAlpha(15),
                          blurRadius: 10,
                          offset: const Offset(0, -3))
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total:',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                          Text(
                            currency.format(total),
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryGreen),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _loading ? null : _confirmOrder,
                          child: _loading
                              ? const CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2)
                              : const Text('Confirmar Pedido'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

// ── Order History ────────────────────────────────────────────────────────
class OrderHistoryScreen extends ConsumerWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(ordersProvider);
    final currency =
        NumberFormat.simpleCurrency(locale: 'es_CO', name: 'COP');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Pedidos'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/client/store'),
        ),
      ),
      body: ordersAsync.when(
        loading: () => const AppLoading(),
        error: (e, _) => AppErrorWidget(
          message: 'Error al cargar pedidos',
          onRetry: () => ref.invalidate(ordersProvider),
        ),
        data: (orders) => orders.isEmpty
            ? const AppEmptyState(
                icon: Icons.receipt_long_outlined,
                title: 'Sin pedidos',
                subtitle:
                    'Aún no tienes pedidos. ¡Haz tu primer pedido!',
              )
            : RefreshIndicator(
                onRefresh: () async => ref.invalidate(ordersProvider),
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: orders.length,
                  itemBuilder: (_, i) {
                    final o = orders[i];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor:
                              o.statusColor.withAlpha(30),
                          child: Icon(Icons.receipt_rounded,
                              color: o.statusColor),
                        ),
                        title: Text(o.commerceName,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600)),
                        subtitle: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(o.createdAt),
                            Container(
                              margin: const EdgeInsets.only(top: 4),
                              padding:
                                  const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: o.statusColor.withAlpha(25),
                                borderRadius:
                                    BorderRadius.circular(8),
                              ),
                              child: Text(
                                o.status,
                                style: TextStyle(
                                    color: o.statusColor,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                        trailing: Text(
                          currency.format(o.total),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryGreen),
                        ),
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }
}
