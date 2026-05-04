import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

// ── Models ────────────────────────────────────────────────────────────────

enum DelivererStatus { disponible, ocupado, inactivo }

extension DelivererStatusExt on DelivererStatus {
  String get label {
    switch (this) {
      case DelivererStatus.disponible:
        return 'DISPONIBLE';
      case DelivererStatus.ocupado:
        return 'OCUPADO';
      case DelivererStatus.inactivo:
        return 'INACTIVO';
    }
  }

  static DelivererStatus fromString(String s) {
    switch (s.toUpperCase()) {
      case 'DISPONIBLE':
        return DelivererStatus.disponible;
      case 'OCUPADO':
        return DelivererStatus.ocupado;
      default:
        return DelivererStatus.inactivo;
    }
  }
}

class DelivererModel {
  final int id;
  final String fullName;
  final String phone;
  final DelivererStatus status;
  final double totalEarnings;
  final int completedDeliveries;

  const DelivererModel({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.status,
    required this.totalEarnings,
    required this.completedDeliveries,
  });

  factory DelivererModel.fromJson(Map<String, dynamic> j) => DelivererModel(
        id: j['id'] as int,
        fullName: j['full_name'] as String? ?? j['user']?['full_name'] as String? ?? '',
        phone: j['phone'] as String? ?? j['user']?['phone'] as String? ?? '',
        status: DelivererStatusExt.fromString(j['status'] as String? ?? 'INACTIVO'),
        totalEarnings: (j['total_earnings'] as num?)?.toDouble() ?? 0.0,
        completedDeliveries: j['completed_deliveries'] as int? ?? 0,
      );
}

class DeliveryRequestModel {
  final int id;
  final String clientName;
  final String? delivererName;
  final String pickupAddress;
  final String deliveryAddress;
  final String description;
  final String status; // pending, assigned, in_progress, completed, cancelled
  final String approvalStatus;
  final double? adminDeliveryFee;
  final bool isDelivered;
  final bool isPaid;
  final double? income;
  final double? expenses;
  final String createdAt;
  final String? completedAt;

  const DeliveryRequestModel({
    required this.id,
    required this.clientName,
    this.delivererName,
    required this.pickupAddress,
    required this.deliveryAddress,
    required this.description,
    required this.status,
    required this.approvalStatus,
    this.adminDeliveryFee,
    required this.isDelivered,
    required this.isPaid,
    this.income,
    this.expenses,
    required this.createdAt,
    this.completedAt,
  });

  factory DeliveryRequestModel.fromJson(Map<String, dynamic> j) {
    final rawStatus = (j['status'] as String? ?? 'SOLICITADO').toUpperCase();
    String normalizedStatus;
    switch (rawStatus) {
      case 'ACEPTADO':
        normalizedStatus = 'assigned';
        break;
      case 'EN_CAMINO':
        normalizedStatus = 'in_progress';
        break;
      case 'ENTREGADO':
        normalizedStatus = 'completed';
        break;
      case 'CANCELADO':
        normalizedStatus = 'cancelled';
        break;
      default:
        normalizedStatus = 'pending';
    }

    return DeliveryRequestModel(
        id: j['id'] as int,
        clientName: j['client_name'] as String? ?? '',
        delivererName: j['deliverer_name'] as String?,
        pickupAddress: j['pickup_address'] as String? ?? '',
        deliveryAddress: j['delivery_address'] as String? ?? '',
        description: j['description'] as String? ?? '',
        status: normalizedStatus,
        approvalStatus: j['approval_status'] as String? ?? 'PENDIENTE',
        adminDeliveryFee: (j['admin_delivery_fee'] as num?)?.toDouble(),
        isDelivered: j['is_delivered'] as bool? ?? false,
        isPaid: j['is_paid'] as bool? ?? false,
        income: (j['income'] as num?)?.toDouble(),
        expenses: (j['expenses'] as num?)?.toDouble(),
        createdAt: j['created_at'] as String? ?? '',
        completedAt: j['completed_at'] as String?,
      );
  }

  String get statusLabel {
    switch (status) {
      case 'pending':
        return 'Pendiente';
      case 'assigned':
        return 'Asignado';
      case 'in_progress':
        return 'En Camino';
      case 'completed':
        return 'Completado';
      case 'cancelled':
        return 'Cancelado';
      default:
        return status;
    }
  }
}

class DeliveryChatMessageModel {
  final int id;
  final String senderName;
  final String recipientRole;
  final String message;
  final String createdAt;

  const DeliveryChatMessageModel({
    required this.id,
    required this.senderName,
    required this.recipientRole,
    required this.message,
    required this.createdAt,
  });

  factory DeliveryChatMessageModel.fromJson(Map<String, dynamic> j) =>
      DeliveryChatMessageModel(
        id: j['id'] as int,
        senderName: j['sender_name'] as String? ?? '',
        recipientRole: j['recipient_role'] as String? ?? '',
        message: j['message'] as String? ?? '',
        createdAt: j['created_at'] as String? ?? '',
      );
}

class FinancialRecordModel {
  final int id;
  final String type; // income / expense
  final double amount;
  final String description;
  final String date;
  final int? deliveryId;

  const FinancialRecordModel({
    required this.id,
    required this.type,
    required this.amount,
    required this.description,
    required this.date,
    this.deliveryId,
  });

  factory FinancialRecordModel.fromJson(Map<String, dynamic> j) =>
      FinancialRecordModel(
        id: j['id'] as int,
        type: j['type'] as String? ?? 'income',
        amount: (j['amount'] as num?)?.toDouble() ?? 0.0,
        description: j['description'] as String? ?? '',
        date: j['date'] as String? ?? '',
        deliveryId: j['delivery'] as int?,
      );
}

// ── Data Source ────────────────────────────────────────────────────────────

class DeliveriesDataSource {
  final Dio _dio;
  DeliveriesDataSource(this._dio);

  /// CLIENT: Create a delivery request — backend auto-assigns an available deliverer
  Future<DeliveryRequestModel> createDeliveryRequest({
    required String pickupAddress,
    required String deliveryAddress,
    required String description,
  }) async {
    final res = await _dio.post(
      ApiConstants.createDeliveryRequest,
      data: {
        'pickup_address': pickupAddress,
        'delivery_address': deliveryAddress,
        'description': description,
      },
    );
    return DeliveryRequestModel.fromJson(res.data as Map<String, dynamic>);
  }

  /// CLIENT: list my delivery requests
  Future<List<DeliveryRequestModel>> getMyDeliveryRequests() async {
    final res = await _dio.get(ApiConstants.deliveryRequests);
    final data = res.data is List ? res.data as List : (res.data['results'] as List? ?? []);
    return data
        .map((j) => DeliveryRequestModel.fromJson(j as Map<String, dynamic>))
        .toList();
  }

  /// DELIVERER: get assigned / active deliveries
  Future<List<DeliveryRequestModel>> getMyDeliveries() async {
    final res = await _dio.get(ApiConstants.myDeliveries);
    final data = res.data is List ? res.data as List : (res.data['results'] as List? ?? []);
    return data
        .map((j) => DeliveryRequestModel.fromJson(j as Map<String, dynamic>))
        .toList();
  }

  /// ADMIN: approve request and set fee
  Future<DeliveryRequestModel> approveDelivery({
    required int id,
    required double fee,
    bool approved = true,
  }) async {
    final res = await _dio.patch(
      ApiConstants.approveDelivery(id),
      data: {'admin_delivery_fee': fee, 'approved': approved},
    );
    return DeliveryRequestModel.fromJson(res.data as Map<String, dynamic>);
  }

  /// DELIVERER: update delivery status (delivered/paid)
  Future<void> completeDelivery(int id, {bool? isDelivered, bool? isPaid}) async {
    await _dio.post(
      ApiConstants.completeDelivery(id),
      data: {
        if (isDelivered != null) 'is_delivered': isDelivered,
        if (isPaid != null) 'is_paid': isPaid,
      },
    );
  }

  Future<List<DeliveryChatMessageModel>> getDeliveryChat(int id) async {
    final res = await _dio.get(ApiConstants.deliveryChat(id));
    final data = res.data is List ? res.data as List : (res.data['results'] as List? ?? []);
    return data
        .map((j) => DeliveryChatMessageModel.fromJson(j as Map<String, dynamic>))
        .toList();
  }

  Future<void> sendDeliveryChatMessage({
    required int id,
    required String message,
    required String recipientRole,
  }) async {
    await _dio.post(
      ApiConstants.deliveryChat(id),
      data: {'message': message, 'recipient_role': recipientRole},
    );
  }

  /// DELIVERER: update own availability status
  Future<void> updateDelivererStatus(DelivererStatus status) async {
    await _dio.patch(
      ApiConstants.delivererStatus,
      data: {'status': status.label},
    );
  }

  /// DELIVERER: get own profile/status
  Future<DelivererModel> getMyDelivererProfile() async {
    final res = await _dio.get(ApiConstants.delivererProfile);
    return DelivererModel.fromJson(res.data as Map<String, dynamic>);
  }

  /// DELIVERER: financial records
  Future<List<FinancialRecordModel>> getFinancialRecords() async {
    final res = await _dio.get(ApiConstants.financialRecords);
    final data = res.data is List ? res.data as List : (res.data['results'] as List? ?? []);
    return data
        .map((j) => FinancialRecordModel.fromJson(j as Map<String, dynamic>))
        .toList();
  }
}

// ── Providers ────────────────────────────────────────────────────────────

final deliveriesDataSourceProvider = Provider<DeliveriesDataSource>((ref) {
  final dio = ref.watch(dioClientProvider).dio;
  return DeliveriesDataSource(dio);
});

final myDeliveryRequestsProvider =
    FutureProvider<List<DeliveryRequestModel>>((ref) {
  return ref.watch(deliveriesDataSourceProvider).getMyDeliveryRequests();
});

final myDeliveriesProvider =
    FutureProvider<List<DeliveryRequestModel>>((ref) {
  return ref.watch(deliveriesDataSourceProvider).getMyDeliveries();
});

final myDelivererProfileProvider = FutureProvider<DelivererModel>((ref) {
  return ref.watch(deliveriesDataSourceProvider).getMyDelivererProfile();
});

final financialRecordsProvider =
    FutureProvider<List<FinancialRecordModel>>((ref) {
  return ref.watch(deliveriesDataSourceProvider).getFinancialRecords();
});
