import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

// ── Models inline simples (sin code generation) ────────────────────────────

class CategoryModel {
  final int id;
  final String name;
  final String description;
  final bool isActive;
  CategoryModel(
      {required this.id,
      required this.name,
      required this.description,
      required this.isActive});
  factory CategoryModel.fromJson(Map<String, dynamic> j) => CategoryModel(
        id: j['id'] as int,
        name: j['name'] as String? ?? '',
        description: j['description'] as String? ?? '',
        isActive: j['is_active'] as bool? ?? true,
      );
}

class ProductModel {
  final int id;
  final int commerce;
  final String name;
  final String description;
  final double price;
  final String? image;
  final bool isAvailable;
  ProductModel(
      {required this.id,
      required this.commerce,
      required this.name,
      required this.description,
      required this.price,
      this.image,
      required this.isAvailable});
  factory ProductModel.fromJson(Map<String, dynamic> j) => ProductModel(
        id: j['id'] as int,
        commerce: j['commerce'] as int? ?? 0,
        name: j['name'] as String? ?? '',
        description: j['description'] as String? ?? '',
        price: (j['price'] as num?)?.toDouble() ?? 0.0,
        image: j['image'] as String?,
        isAvailable: j['is_available'] as bool? ?? true,
      );
}

class CommerceModel {
  final int id;
  final int categoryId;
  final String categoryName;
  final String name;
  final String description;
  final String phone;
  final String? image;
  final bool isActive;
  CommerceModel(
      {required this.id,
      required this.categoryId,
      required this.categoryName,
      required this.name,
      required this.description,
      required this.phone,
      this.image,
      required this.isActive});
  factory CommerceModel.fromJson(Map<String, dynamic> j) => CommerceModel(
        id: j['id'] as int,
        categoryId: j['category'] as int? ?? 0,
        categoryName: j['category_name'] as String? ?? '',
        name: j['name'] as String? ?? '',
        description: j['description'] as String? ?? '',
        phone: j['phone'] as String? ?? '',
        image: j['image'] as String?,
        isActive: j['is_active'] as bool? ?? true,
      );
}

class OrderItemInput {
  final int productId;
  final String productName;
  final double unitPrice;
  int quantity;
  OrderItemInput(
      {required this.productId,
      required this.productName,
      required this.unitPrice,
      required this.quantity});
  double get subtotal => unitPrice * quantity;
}

class OrderModel {
  final int id;
  final String clientName;
  final String commerceName;
  final String status;
  final double total;
  final String notes;
  final String createdAt;
  OrderModel(
      {required this.id,
      required this.clientName,
      required this.commerceName,
      required this.status,
      required this.total,
      required this.notes,
      required this.createdAt});
  factory OrderModel.fromJson(Map<String, dynamic> j) => OrderModel(
        id: j['id'] as int,
        clientName: j['client_name'] as String? ?? '',
        commerceName: j['commerce_name'] as String? ?? '',
        status: j['status'] as String? ?? 'PENDIENTE',
        total: (j['total'] as num?)?.toDouble() ?? 0.0,
        notes: j['notes'] as String? ?? '',
        createdAt: j['created_at'] as String? ?? '',
      );
  Color get statusColor {
    switch (status) {
      case 'CONFIRMADO':
        return const Color(0xFF1565C0);
      case 'EN_CAMINO':
        return const Color(0xFF7B1FA2);
      case 'ENTREGADO':
        return const Color(0xFF2E7D32);
      case 'CANCELADO':
        return const Color(0xFFC62828);
      default:
        return const Color(0xFFFF8F00);
    }
  }
}

// ── DataSource ──────────────────────────────────────────────────────────────
class StoreDataSource {
  final Dio _dio;
  StoreDataSource(this._dio);

  Future<List<CategoryModel>> getCategories() async {
    final r = await _dio.get('/store/categories/');
    final list =
        (r.data as Map<String, dynamic>)['results'] as List? ?? r.data as List;
    return list
        .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<CommerceModel>> getCommerces({int? categoryId}) async {
    final r = await _dio.get(
      '/store/commerces/',
      queryParameters:
          categoryId != null ? {'category': categoryId} : null,
    );
    final list =
        (r.data as Map<String, dynamic>)['results'] as List? ?? r.data as List;
    return list
        .map((e) => CommerceModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<ProductModel>> getProducts(int commerceId) async {
    final r = await _dio.get('/store/commerces/$commerceId/products/');
    final list =
        (r.data as Map<String, dynamic>)['results'] as List? ?? r.data as List;
    return list
        .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<OrderModel> createOrder(Map<String, dynamic> data) async {
    final r = await _dio.post('/store/orders/create/', data: data);
    return OrderModel.fromJson(r.data as Map<String, dynamic>);
  }

  Future<List<OrderModel>> getOrders() async {
    final r = await _dio.get('/store/orders/');
    final list =
        (r.data as Map<String, dynamic>)['results'] as List? ?? r.data as List;
    return list
        .map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}

// ── Providers ───────────────────────────────────────────────────────────────
final storeDataSourceProvider = Provider<StoreDataSource>((ref) {
  final dio = ref.read(dioClientProvider).dio;
  return StoreDataSource(dio);
});

final categoriesProvider = FutureProvider<List<CategoryModel>>((ref) {
  return ref.read(storeDataSourceProvider).getCategories();
});

final selectedCategoryProvider = StateProvider<int?>((ref) => null);

final commercesProvider = FutureProvider<List<CommerceModel>>((ref) {
  final categoryId = ref.watch(selectedCategoryProvider);
  return ref.read(storeDataSourceProvider).getCommerces(categoryId: categoryId);
});

final commerceDetailProvider =
    FutureProvider.family<CommerceModel, int>((ref, id) async {
  final commerces = await ref.watch(commercesProvider.future);
  return commerces.firstWhere((c) => c.id == id,
      orElse: () => CommerceModel(
          id: id,
          categoryId: 0,
          categoryName: '',
          name: '',
          description: '',
          phone: '',
          isActive: true));
});

final commerceProductsProvider =
    FutureProvider.family<List<ProductModel>, int>((ref, commerceId) {
  return ref.read(storeDataSourceProvider).getProducts(commerceId);
});

final ordersProvider = FutureProvider<List<OrderModel>>((ref) {
  return ref.read(storeDataSourceProvider).getOrders();
});

// Carrito
class CartNotifier extends StateNotifier<List<OrderItemInput>> {
  CartNotifier() : super([]);
  int? _commerceId;

  void addItem(OrderItemInput item, int commerceId) {
    if (_commerceId != null && _commerceId != commerceId) {
      clearCart();
    }
    _commerceId = commerceId;
    final idx = state.indexWhere((i) => i.productId == item.productId);
    if (idx >= 0) {
      state = [
        for (int i = 0; i < state.length; i++)
          if (i == idx)
            OrderItemInput(
              productId: state[i].productId,
              productName: state[i].productName,
              unitPrice: state[i].unitPrice,
              quantity: state[i].quantity + 1,
            )
          else
            state[i]
      ];
    } else {
      state = [...state, item];
    }
  }

  void removeItem(int productId) {
    state = state.where((i) => i.productId != productId).toList();
    if (state.isEmpty) _commerceId = null;
  }

  void decreaseQuantity(int productId) {
    state = [
      for (final item in state)
        if (item.productId == productId && item.quantity > 1)
          OrderItemInput(
            productId: item.productId,
            productName: item.productName,
            unitPrice: item.unitPrice,
            quantity: item.quantity - 1,
          )
        else if (item.productId == productId && item.quantity == 1)
          item
        else
          item
    ].where((i) => i.quantity > 0).toList();
  }

  void clearCart() {
    state = [];
    _commerceId = null;
  }

  double get total => state.fold(0, (s, i) => s + i.subtotal);
  int get itemCount => state.fold(0, (s, i) => s + i.quantity);
  int? get currentCommerceId => _commerceId;

  Map<String, dynamic> toOrderPayload() => {
        'commerce_id': _commerceId,
        'items': state
            .map((i) => {'product': i.productId, 'quantity': i.quantity})
            .toList(),
      };
}

final cartProvider =
    StateNotifierProvider<CartNotifier, List<OrderItemInput>>(
        (_) => CartNotifier());
