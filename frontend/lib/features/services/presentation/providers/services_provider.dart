import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

// ── Models ────────────────────────────────────────────────────────────────

class ServiceCategoryModel {
  final int id;
  final String name;
  final String description;

  const ServiceCategoryModel({
    required this.id,
    required this.name,
    required this.description,
  });

  factory ServiceCategoryModel.fromJson(Map<String, dynamic> j) =>
      ServiceCategoryModel(
        id: j['id'] as int,
        name: j['name'] as String? ?? '',
        description: j['description'] as String? ?? '',
      );
}

class ProviderModel {
  final int id;
  final String fullName;
  final String profession;
  final String description;
  final String phone;
  final String? photoUrl;
  final String? cvUrl;
  final bool isApproved;
  final String userId;

  const ProviderModel({
    required this.id,
    required this.fullName,
    required this.profession,
    required this.description,
    required this.phone,
    this.photoUrl,
    this.cvUrl,
    required this.isApproved,
    required this.userId,
  });

  factory ProviderModel.fromJson(Map<String, dynamic> j) => ProviderModel(
        id: j['id'] as int,
        fullName: j['full_name'] as String? ?? j['user']?['full_name'] as String? ?? '',
        profession: j['profession'] as String? ?? '',
        description: j['description'] as String? ?? '',
        phone: j['phone'] as String? ?? j['user']?['phone'] as String? ?? '',
        photoUrl: j['photo'] as String?,
        cvUrl: j['cv'] as String?,
        isApproved: j['is_approved'] as bool? ?? false,
        userId: j['user']?['id']?.toString() ?? '',
      );
}

class ServiceRequestModel {
  final int id;
  final String clientName;
  final String providerName;
  final String description;
  final String status; // pending, in_progress, completed, cancelled
  final String createdAt;
  final String? adminNote;

  const ServiceRequestModel({
    required this.id,
    required this.clientName,
    required this.providerName,
    required this.description,
    required this.status,
    required this.createdAt,
    this.adminNote,
  });

  factory ServiceRequestModel.fromJson(Map<String, dynamic> j) =>
      ServiceRequestModel(
        id: j['id'] as int,
        clientName: j['client_name'] as String? ?? '',
        providerName: j['provider_name'] as String? ?? '',
        description: j['description'] as String? ?? '',
        status: j['status'] as String? ?? 'pending',
        createdAt: j['created_at'] as String? ?? '',
        adminNote: j['admin_note'] as String?,
      );

  String get statusLabel {
    switch (status) {
      case 'pending':
        return 'Pendiente';
      case 'in_progress':
        return 'En Proceso';
      case 'completed':
        return 'Completado';
      case 'cancelled':
        return 'Cancelado';
      default:
        return status;
    }
  }
}

// ── Data Source ────────────────────────────────────────────────────────────

class ServicesDataSource {
  final Dio _dio;
  ServicesDataSource(this._dio);

  Future<List<ServiceCategoryModel>> getServiceCategories() async {
    final res = await _dio.get(ApiConstants.serviceCategories);
    final data = res.data is List ? res.data as List : (res.data['results'] as List? ?? []);
    return data.map((j) => ServiceCategoryModel.fromJson(j as Map<String, dynamic>)).toList();
  }

  Future<List<ProviderModel>> getProviders({int? categoryId}) async {
    final res = await _dio.get(
      ApiConstants.providers,
      queryParameters: {
        if (categoryId != null) 'category': categoryId,
        'is_approved': true,
      },
    );
    final data = res.data is List ? res.data as List : (res.data['results'] as List? ?? []);
    return data.map((j) => ProviderModel.fromJson(j as Map<String, dynamic>)).toList();
  }

  Future<ProviderModel> getProviderDetail(int providerId) async {
    final res = await _dio.get(ApiConstants.providerDetail(providerId));
    return ProviderModel.fromJson(res.data as Map<String, dynamic>);
  }

  Future<void> createServiceRequest({
    required int providerId,
    required String description,
  }) async {
    await _dio.post(
      ApiConstants.serviceRequests,
      data: {
        'provider': providerId,
        'description': description,
      },
    );
  }

  Future<List<ServiceRequestModel>> getMyServiceRequests() async {
    final res = await _dio.get(ApiConstants.serviceRequests);
    final data = res.data is List ? res.data as List : (res.data['results'] as List? ?? []);
    return data.map((j) => ServiceRequestModel.fromJson(j as Map<String, dynamic>)).toList();
  }

  Future<void> registerAsProvider({
    required int categoryId,
    required String profession,
    required String description,
    String? cvPath,
  }) async {
    FormData formData = FormData.fromMap({
      'category': categoryId,
      'profession': profession,
      'description': description,
      if (cvPath != null)
        'cv': await MultipartFile.fromFile(cvPath, filename: 'cv.pdf'),
    });
    await _dio.post(ApiConstants.registerProvider, data: formData);
  }

  Future<ProviderModel> getMyProviderProfile() async {
    final res = await _dio.get(ApiConstants.myProviderProfile);
    return ProviderModel.fromJson(res.data as Map<String, dynamic>);
  }
}

// ── Providers ────────────────────────────────────────────────────────────

final servicesDataSourceProvider = Provider<ServicesDataSource>((ref) {
  final dio = ref.watch(dioClientProvider).dio;
  return ServicesDataSource(dio);
});

final serviceCategoriesProvider = FutureProvider<List<ServiceCategoryModel>>((ref) {
  return ref.watch(servicesDataSourceProvider).getServiceCategories();
});

final selectedServiceCategoryProvider = StateProvider<int?>((ref) => null);

final providersProvider = FutureProvider<List<ProviderModel>>((ref) {
  final categoryId = ref.watch(selectedServiceCategoryProvider);
  return ref.watch(servicesDataSourceProvider).getProviders(categoryId: categoryId);
});

final providerDetailProvider =
    FutureProvider.family<ProviderModel, int>((ref, id) {
  return ref.watch(servicesDataSourceProvider).getProviderDetail(id);
});

final myServiceRequestsProvider =
    FutureProvider<List<ServiceRequestModel>>((ref) {
  return ref.watch(servicesDataSourceProvider).getMyServiceRequests();
});

final myProviderProfileProvider = FutureProvider<ProviderModel>((ref) {
  return ref.watch(servicesDataSourceProvider).getMyProviderProfile();
});
