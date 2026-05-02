import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/store_provider.dart';
import '../../../../shared/widgets/app_loading.dart';
import '../../../../shared/widgets/app_error_widget.dart';
import '../../../../shared/widgets/app_empty_state.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/utils/media_url.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/domain/entities/user_entity.dart';

void _redirectGuestToLogin(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Debes iniciar sesión para realizar compras.'),
    ),
  );
  context.go(AppRoutes.login);
}

class StoreScreen extends ConsumerWidget {
  const StoreScreen({super.key});

  bool _isImageMenu(String? url) {
    if (url == null || url.isEmpty) return false;
    final path = Uri.parse(url).path.toLowerCase();
    return path.endsWith('.jpg') ||
        path.endsWith('.jpeg') ||
        path.endsWith('.png') ||
        path.endsWith('.webp');
  }

  Widget _buildCommerceAvatar(CommerceModel commerce) {
    final imageUrl = resolveMediaUrl(commerce.image);
    
    // If we have an image URL, show it; otherwise show icon
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return CircleAvatar(
        radius: 24,
        backgroundColor: AppColors.primaryGreen.withAlpha(20),
        backgroundImage: NetworkImage(imageUrl),
      );
    }
    
    // Default icon if no image
    return CircleAvatar(
      radius: 24,
      backgroundColor: AppColors.primaryGreen.withAlpha(20),
      child: const Icon(
        Icons.store_rounded,
        color: AppColors.primaryGreen,
      ),
    );
  }

  void _openMenu(BuildContext context, String? menuUrl) {
    final resolvedUrl = resolveMediaUrl(menuUrl);
    if (resolvedUrl == null) return;
    
    // Open URLs in app for PDFs and images
    launchUrl(
      Uri.parse(resolvedUrl),
      mode: LaunchMode.inAppWebView,
    );
  }

  Widget _buildMenuPreview(BuildContext context, CommerceModel commerce) {
    final menuUrl = resolveMediaUrl(commerce.menuPdf);
    if (menuUrl == null) {
      return const SizedBox.shrink();
    }

    final isImage = _isImageMenu(menuUrl);

    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primaryGreen.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primaryGreen.withValues(alpha: 0.14),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.menu_book_outlined,
                size: 18,
                color: AppColors.primaryGreen,
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Carta disponible',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                ),
              ),
              TextButton(
                onPressed: () => _openMenu(context, commerce.menuPdf),
                child: const Text('Abrir'),
              ),
            ],
          ),
          if (isImage)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  menuUrl,
                  width: double.infinity,
                  height: 180,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const SizedBox(
                    height: 180,
                    child: Center(child: Text('No se pudo cargar la carta')),
                  ),
                ),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                'La carta está en PDF y se abre con un toque.',
                style: TextStyle(
                  color: AppColors.textSecondary.withValues(alpha: 0.95),
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _openProfileMenu(
    BuildContext context,
    WidgetRef ref,
    UserEntity? user,
    bool isGuest,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primaryGreen.withValues(
                      alpha: 0.1,
                    ),
                    backgroundImage:
                        resolveMediaUrl(user?.profileImageUrl) != null
                        ? NetworkImage(resolveMediaUrl(user?.profileImageUrl)!)
                        : null,
                    child: resolveMediaUrl(user?.profileImageUrl) == null
                        ? const Icon(Icons.person_outline)
                        : null,
                  ),
                  title: Text(
                    user?.fullName.isNotEmpty == true
                        ? user!.fullName
                        : (isGuest ? 'Modo invitado' : 'Mi perfil'),
                  ),
                  subtitle: Text(user?.email ?? 'Sin correo'),
                ),
                if (!isGuest)
                  ListTile(
                    leading: const Icon(Icons.edit_outlined),
                    title: const Text('Editar perfil'),
                    onTap: () async {
                      Navigator.of(sheetContext).pop();
                      if (context.mounted) {
                        context.push(AppRoutes.clientProfile);
                      }
                    },
                  ),
                ListTile(
                  leading: Icon(
                    isGuest ? Icons.login_rounded : Icons.logout,
                    color: Colors.red,
                  ),
                  title: Text(
                    isGuest ? 'Iniciar sesión' : 'Cerrar sesión',
                    style: const TextStyle(color: Colors.red),
                  ),
                  onTap: () async {
                    Navigator.of(sheetContext).pop();
                    if (!isGuest) {
                      await ref.read(authProvider.notifier).logout();
                    }
                    if (context.mounted) {
                      context.go(AppRoutes.login);
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<bool> _openEditProfileDialog(
    BuildContext context,
    WidgetRef ref,
    UserEntity? user,
  ) async {
    final firstNameController = TextEditingController(
      text: user?.firstName ?? '',
    );
    final lastNameController = TextEditingController(
      text: user?.lastName ?? '',
    );
    final phoneController = TextEditingController(text: user?.phone ?? '');

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Editar perfil'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: firstNameController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(labelText: 'Nombre'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: lastNameController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(labelText: 'Apellidos'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Teléfono'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () async {
                final firstName = firstNameController.text.trim();
                final lastName = lastNameController.text.trim();
                if (firstName.isEmpty || lastName.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Nombre y apellidos son obligatorios'),
                    ),
                  );
                  return;
                }

                final ok = await ref
                    .read(authProvider.notifier)
                    .updateProfile(
                      firstName: firstName,
                      lastName: lastName,
                      phone: phoneController.text.trim(),
                    );
                if (!dialogContext.mounted) return;

                if (ok) {
                  Navigator.of(dialogContext).pop(true);
                } else {
                  final error =
                      ref.read(authProvider).error ??
                      'No fue posible actualizar el perfil';
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(error)));
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );

    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    return result ?? false;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final commercesAsync = ref.watch(commercesProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final cart = ref.watch(cartProvider);
    final authState = ref.watch(authProvider);
    final user = authState.user;
    final isGuest = authState.isGuest;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.person_outline),
          tooltip: 'Perfil',
          onPressed: () => _openProfileMenu(context, ref, user, isGuest),
        ),
        title: const Text('Tienda Runners'),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                onPressed: () {
                  if (isGuest) {
                    _redirectGuestToLogin(context);
                    return;
                  }
                  context.go('/client/cart');
                },
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
                      style: const TextStyle(color: Colors.white, fontSize: 10),
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
              child: Center(child: AppLoading(size: 24)),
            ),
            error: (_, __) => const SizedBox(),
            data: (categories) => SizedBox(
              height: 56,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: const Text('Todos'),
                      selected: selectedCategory == null,
                      selectedColor: AppColors.primaryGreen.withAlpha(30),
                      onSelected: (_) =>
                          ref.read(selectedCategoryProvider.notifier).state =
                              null,
                    ),
                  ),
                  ...categories.map(
                    (cat) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(cat.name),
                        selected: selectedCategory == cat.id,
                        selectedColor: AppColors.primaryGreen.withAlpha(30),
                        onSelected: (_) =>
                            ref.read(selectedCategoryProvider.notifier).state =
                                cat.id,
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
                      onRefresh: () async => ref.invalidate(commercesProvider),
                      child: ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: commerces.length,
                        itemBuilder: (_, i) {
                          final c = commerces[i];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: InkWell(
                              onTap: () => context.go('/client/store/${c.id}'),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        _buildCommerceAvatar(c),
                                        // CircleAvatar(
                                        //   backgroundColor: AppColors
                                        //       .primaryGreen
                                        //       .withAlpha(20),
                                        //   child: const Icon(
                                        //     Icons.store_rounded,
                                        //     color: AppColors.primaryGreen,
                                        //   ),
                                        // ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                c.name,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              Text(
                                                c.description,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          size: 16,
                                        ),
                                      ],
                                    ),
                                    _buildMenuPreview(context, c),
                                    if (c.phone.isNotEmpty ||
                                        c.address.isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Wrap(
                                          spacing: 12,
                                          runSpacing: 6,
                                          children: [
                                            if (c.phone.isNotEmpty)
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    Icons.phone_outlined,
                                                    size: 14,
                                                    color:
                                                        AppColors.textSecondary,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    c.phone,
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            if (c.address.isNotEmpty)
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    Icons.location_on_outlined,
                                                    size: 14,
                                                    color:
                                                        AppColors.textSecondary,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    c.address,
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                              ),
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
        onPressed: () {
          if (isGuest) {
            _redirectGuestToLogin(context);
            return;
          }
          context.go('/client/orders');
        },
        icon: const Icon(Icons.history, color: Colors.white),
        label: const Text('Mis Pedidos', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}

// ── Commerce Detail ──────────────────────────────────────────────────────
class CommerceDetailScreen extends ConsumerWidget {
  final int commerceId;
  const CommerceDetailScreen({super.key, required this.commerceId});

  Future<void> _openMenu(String url) async {
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  bool _isImageUrl(String url) {
    final lower = Uri.parse(url).path.toLowerCase();
    return lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg') ||
        lower.endsWith('.png') ||
        lower.endsWith('.webp');
  }

  Widget _buildMenuSection(BuildContext context, CommerceModel commerce) {
    final menuUrl = resolveMediaUrl(commerce.menuPdf);
    if (menuUrl == null) return const SizedBox.shrink();

    final isImage = _isImageUrl(menuUrl);

    return Card(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Carta del restaurante',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            if (isImage)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  menuUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (_, __, ___) => const SizedBox(
                    height: 140,
                    child: Center(child: Text('No se pudo cargar la carta')),
                  ),
                ),
              )
            else
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.primaryGreen.withValues(alpha: 0.18),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.picture_as_pdf_outlined,
                      color: AppColors.primaryGreen,
                      size: 36,
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'La carta está disponible como PDF. Puedes abrirla para verla completa.',
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                    TextButton(
                      onPressed: () => _openMenu(menuUrl),
                      child: const Text('Ver carta'),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commerceAsync = ref.watch(commerceDetailProvider(commerceId));
    final productsAsync = ref.watch(commerceProductsProvider(commerceId));
    final cart = ref.watch(cartProvider);
    final isGuest = ref.watch(authProvider).isGuest;
    final currency = NumberFormat.simpleCurrency(locale: 'es_CO', name: 'COP');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Menú / Catálogo'),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                onPressed: () {
                  if (isGuest) {
                    _redirectGuestToLogin(context);
                    return;
                  }
                  context.go('/client/cart');
                },
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
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: commerceAsync.when(
        loading: () => const AppLoading(),
        error: (e, _) => AppErrorWidget(
          message: 'Error al cargar el comercio',
          onRetry: () => ref.invalidate(commerceDetailProvider(commerceId)),
        ),
        data: (commerce) => productsAsync.when(
          loading: () => const AppLoading(),
          error: (e, _) => AppErrorWidget(
            message: 'Error al cargar productos',
            onRetry: () => ref.invalidate(commerceProductsProvider(commerceId)),
          ),
          data: (products) => ListView(
            children: [
              _buildMenuSection(context, commerce),
              if (products.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 24),
                  child: AppEmptyState(
                    icon: Icons.inventory_2_outlined,
                    title: 'Sin productos',
                    subtitle:
                        'Este comercio aún no tiene productos registrados.',
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(12),
                  itemCount: products.length,
                  itemBuilder: (_, i) {
                    final p = products[i];
                    final inCart = cart.indexWhere((c) => c.productId == p.id);
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: AppColors.primaryGreen.withAlpha(
                                15,
                              ),
                              child: const Icon(
                                Icons.fastfood_rounded,
                                color: AppColors.primaryGreen,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    p.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  if (p.description.isNotEmpty)
                                    Text(
                                      p.description,
                                      style: const TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: 12,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
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
                              const Text(
                                'No disponible',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 11,
                                ),
                              )
                            else if (inCart >= 0)
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.remove_circle,
                                      color: AppColors.error,
                                    ),
                                    onPressed: () => ref
                                        .read(cartProvider.notifier)
                                        .decreaseQuantity(p.id),
                                  ),
                                  Text(
                                    '${cart[inCart].quantity}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.add_circle,
                                      color: AppColors.primaryGreen,
                                    ),
                                    onPressed: () {
                                      if (isGuest) {
                                        _redirectGuestToLogin(context);
                                        return;
                                      }
                                      ref
                                          .read(cartProvider.notifier)
                                          .addItem(
                                            OrderItemInput(
                                              productId: p.id,
                                              productName: p.name,
                                              unitPrice: p.price,
                                              quantity: 1,
                                            ),
                                            commerceId,
                                          );
                                    },
                                  ),
                                ],
                              )
                            else
                              ElevatedButton(
                                onPressed: () {
                                  if (isGuest) {
                                    _redirectGuestToLogin(context);
                                    return;
                                  }
                                  ref
                                      .read(cartProvider.notifier)
                                      .addItem(
                                        OrderItemInput(
                                          productId: p.id,
                                          productName: p.name,
                                          unitPrice: p.price,
                                          quantity: 1,
                                        ),
                                        commerceId,
                                      );
                                },
                                child: const Text('Agregar'),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  bool _loading = false;
  String? _error;

  Future<void> _confirmOrder() async {
    if (ref.read(authProvider).isGuest) {
      _redirectGuestToLogin(context);
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final cartNotifier = ref.read(cartProvider.notifier);
      final payload = cartNotifier.toOrderPayload();
      final order = await ref
          .read(storeDataSourceProvider)
          .createOrder(payload);
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
    final currency = NumberFormat.simpleCurrency(locale: 'es_CO', name: 'COP');
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
                    child: Text(
                      _error!,
                      style: const TextStyle(color: AppColors.error),
                    ),
                  ),
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.length,
                    itemBuilder: (_, i) {
                      final item = cart[i];
                      return ListTile(
                        title: Text(item.productName),
                        subtitle: Text(currency.format(item.unitPrice)),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.remove_circle,
                                color: AppColors.error,
                              ),
                              onPressed: () => ref
                                  .read(cartProvider.notifier)
                                  .removeItem(item.productId),
                            ),
                            Text(
                              '${item.quantity}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.add_circle,
                                color: AppColors.primaryGreen,
                              ),
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
                        offset: const Offset(0, -3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            currency.format(total),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryGreen,
                            ),
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
                                  color: Colors.white,
                                  strokeWidth: 2,
                                )
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
    final currency = NumberFormat.simpleCurrency(locale: 'es_CO', name: 'COP');

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
                subtitle: 'Aún no tienes pedidos. ¡Haz tu primer pedido!',
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
                          backgroundColor: o.statusColor.withAlpha(30),
                          child: Icon(
                            Icons.receipt_rounded,
                            color: o.statusColor,
                          ),
                        ),
                        title: Text(
                          o.commerceName,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(o.createdAt),
                            Container(
                              margin: const EdgeInsets.only(top: 4),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: o.statusColor.withAlpha(25),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                o.status,
                                style: TextStyle(
                                  color: o.statusColor,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        trailing: Text(
                          currency.format(o.total),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryGreen,
                          ),
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
