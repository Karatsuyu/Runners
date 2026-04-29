import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../../core/constants/api_constants.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Admin Commerce Models
// ─────────────────────────────────────────────────────────────────────────────

class AdminCommerceModel {
  final int id;
  final int categoryId;
  final String categoryName;
  final String name;
  final String description;
  final String phone;
  final String address;
  final String? image;
  final String? menuPdf;
  final bool isActive;
  final String createdAt;
  final String updatedAt;

  AdminCommerceModel({
    required this.id,
    required this.categoryId,
    required this.categoryName,
    required this.name,
    required this.description,
    required this.phone,
    required this.address,
    this.image,
    this.menuPdf,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AdminCommerceModel.fromJson(Map<String, dynamic> json) {
    return AdminCommerceModel(
      id: json['id'] as int? ?? 0,
      categoryId: json['category'] as int? ?? 0,
      categoryName: json['category_name'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      address: json['address'] as String? ?? '',
      image: json['image'] as String?,
      menuPdf: json['menu_pdf'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: json['created_at'] as String? ?? '',
      updatedAt: json['updated_at'] as String? ?? '',
    );
  }
}

class AdminCategoryModel {
  final int id;
  final String name;

  AdminCategoryModel({required this.id, required this.name});

  factory AdminCategoryModel.fromJson(Map<String, dynamic> json) {
    return AdminCategoryModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Admin Store Data Source
// ─────────────────────────────────────────────────────────────────────────────

class AdminStoreDataSource {
  final Dio _dio;

  AdminStoreDataSource(this._dio);

  Future<List<AdminCommerceModel>> getAllCommerces({
    int? categoryId,
    bool? isActive,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (categoryId != null) queryParams['category'] = categoryId;
      if (isActive != null) queryParams['is_active'] = isActive;

      final response = await _dio.get(
        ApiConstants.manageCommerces,
        queryParameters: queryParams.isEmpty ? null : queryParams,
      );

      final list = response.data is List
          ? response.data as List
          : (response.data['results'] as List? ?? []);

      return list
          .map((e) => AdminCommerceModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<AdminCommerceModel> getCommerceDetail(int id) async {
    try {
      final response = await _dio.get('${ApiConstants.manageCommerces}$id/');
      return AdminCommerceModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  Future<AdminCommerceModel> createCommerce(FormData data) async {
    try {
      final response = await _dio.post(
        ApiConstants.manageCommerces,
        data: data,
      );
      return AdminCommerceModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  Future<AdminCommerceModel> updateCommerce(int id, FormData data) async {
    try {
      final response = await _dio.put(
        '${ApiConstants.manageCommerces}$id/',
        data: data,
      );
      return AdminCommerceModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteCommerce(int id) async {
    try {
      await _dio.delete('${ApiConstants.manageCommerces}$id/');
    } catch (e) {
      rethrow;
    }
  }
}

class AdminStoreCategoryDataSource {
  final Dio _dio;

  AdminStoreCategoryDataSource(this._dio);

  Future<List<AdminCategoryModel>> getCategories() async {
    final response = await _dio.get(ApiConstants.categories);
    final data = response.data is List
        ? response.data as List
        : (response.data['results'] as List? ?? []);
    return data
        .map((e) => AdminCategoryModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Admin Store Repository
// ─────────────────────────────────────────────────────────────────────────────

class AdminStoreRepository {
  final AdminStoreDataSource _dataSource;

  AdminStoreRepository(this._dataSource);

  Future<List<AdminCommerceModel>> getAllCommerces({
    int? categoryId,
    bool? isActive,
  }) async {
    return _dataSource.getAllCommerces(categoryId: categoryId, isActive: isActive);
  }

  Future<AdminCommerceModel> getCommerceDetail(int id) async {
    return _dataSource.getCommerceDetail(id);
  }

  Future<AdminCommerceModel> createCommerce(FormData data) async {
    return _dataSource.createCommerce(data);
  }

  Future<AdminCommerceModel> updateCommerce(int id, FormData data) async {
    return _dataSource.updateCommerce(id, data);
  }

  Future<void> deleteCommerce(int id) async {
    return _dataSource.deleteCommerce(id);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Providers
// ─────────────────────────────────────────────────────────────────────────────

final adminStoreDataSourceProvider = Provider<AdminStoreDataSource>((ref) {
  final dio = ref.read(dioClientProvider).dio;
  return AdminStoreDataSource(dio);
});

final adminStoreCategoryDataSourceProvider =
    Provider<AdminStoreCategoryDataSource>((ref) {
  final dio = ref.read(dioClientProvider).dio;
  return AdminStoreCategoryDataSource(dio);
});

final storeAdminProvider = Provider<AdminStoreRepository>((ref) {
  final dataSource = ref.read(adminStoreDataSourceProvider);
  return AdminStoreRepository(dataSource);
});

final adminCommercesProvider = FutureProvider<List<AdminCommerceModel>>((ref) async {
  final repository = ref.read(storeAdminProvider);
  return repository.getAllCommerces();
});

final adminCommerceDetailProvider =
    FutureProvider.family<AdminCommerceModel, int>((ref, id) async {
  final repository = ref.read(storeAdminProvider);
  return repository.getCommerceDetail(id);
});

final adminCategoriesProvider = FutureProvider<List<AdminCategoryModel>>((ref) async {
  final dataSource = ref.read(adminStoreCategoryDataSourceProvider);
  return dataSource.getCategories();
});

final adminCommerceFilterProvider = StateProvider<({int? categoryId, bool? isActive})>((ref) {
  return (categoryId: null, isActive: null);
});

final adminCommercesFilteredProvider =
    FutureProvider<List<AdminCommerceModel>>((ref) async {
  final filter = ref.watch(adminCommerceFilterProvider);
  final repository = ref.read(storeAdminProvider);
  return repository.getAllCommerces(
    categoryId: filter.categoryId,
    isActive: filter.isActive,
  );
});
