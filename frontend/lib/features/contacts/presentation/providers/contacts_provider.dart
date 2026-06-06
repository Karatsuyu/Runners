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
      case 'SERVICIO':
        return 'servicio';
      case 'CONTACTO':
        return 'contacto';
      case 'OTRO':
        return 'other';
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
      case 'servicio':
        return 'Servicio';
      case 'contacto':
        return 'Contacto';
      case 'other':
        return 'Otro';
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
    final Map<String, dynamic> map = {...contact.toJson()};
    // Normalize phone to avoid server-side validation errors (trim + max 20)
    if (map.containsKey('phone') && map['phone'] != null) {
      final p = map['phone'].toString().trim();
      map['phone'] = p.length > 20 ? p.substring(0, 20) : p;
    }
    // Ensure backend enum field `contact_type` is provided (Django expects uppercase codes)
    String mapContactType(String t) {
      switch (t) {
        case 'emergency':
          return 'EMERGENCIA';
        case 'professional':
          return 'PROFESIONAL';
        case 'commerce':
          return 'COMERCIO';
        case 'contacto':
          return 'CONTACTO';
        case 'servicio':
          return 'SERVICIO';
        default:
          // Unknown/custom types should be sent as 'OTRO' so the backend
          // accepts the value (backend has a fixed set of choices).
          return 'OTRO';
      }
    }
    final finalType = (map['type'] ?? contact.type) as String?;
    if (finalType != null) {
      try {
        map['contact_type'] = mapContactType(finalType);
      } catch (_) {
        map['contact_type'] = 'OTRO';
      }
    }
    // Avoid sending the user-friendly `type` field which may contain
    // custom values; rely on `contact_type` for backend validation.
    map.remove('type');
    // Don't send the user-facing `type` field to the API. The backend
    // expects the enum in `contact_type`; if `type` is present it takes
    // precedence in validation and may contain custom values that cause
    // a 400. Remove it to rely on `contact_type` only.
    map.remove('type');
    // Keep a raw copy of the map (with image path string if provided) so we
    // can rebuild a fresh FormData if the request needs to be retried after
    // token refresh. Do not include MultipartFile in the raw map.
    final rawMap = Map<String, dynamic>.from(map);
    if (imagePath != null && imagePath.isNotEmpty) {
      map['image'] = await MultipartFile.fromFile(imagePath);
      rawMap['image'] = imagePath; // store path for potential retry
    }
    final payload = FormData.fromMap(map);
    // debug: print url and keys to help diagnose server 500
    try {
      // ignore: avoid_print
      print('ContactsDataSource.createContact POST -> ${_dio.options.baseUrl}${ApiConstants.contacts}');
      // ignore: avoid_print
      print('Payload keys: ${map.keys.toList()}');
        final res = await _dio.post(ApiConstants.contacts,
          data: payload,
          options: Options(extra: {'_disable_retry': true, '_form_map_raw': rawMap}));
      return ContactModel.fromJson(res.data as Map<String, dynamic>);
    } catch (e) {
      final de = e as dynamic;
      // ignore: avoid_print
      print('Contacts create error: status=${de?.response?.statusCode} body=${de?.response?.data} error=${de?.message ?? de}');
      // try to extract friendly message from response
      try {
        final resp = de?.response?.data;
        if (resp is Map) {
          if (resp.containsKey('detail')) {
            throw Exception(resp['detail'].toString());
          }
          final parts = resp.entries.map((entry) {
            final v = entry.value;
            if (v is List) return '${entry.key}: ${v.join(', ')}';
            return '${entry.key}: $v';
          }).join(' \n');
          throw Exception(parts);
        }
      } catch (_) {}
      rethrow;
    }
  }

  Future<ContactModel> updateContact(
    int id,
    ContactModel contact, {
    String? imagePath,
  }) async {
    final Map<String, dynamic> map = {...contact.toJson()};
    String mapContactType(String t) {
      switch (t) {
        case 'emergency':
          return 'EMERGENCIA';
        case 'professional':
          return 'PROFESIONAL';
        case 'commerce':
          return 'COMERCIO';
        case 'contacto':
          return 'CONTACTO';
        case 'servicio':
          return 'SERVICIO';
        default:
          return 'OTRO';
      }
    }
    final finalType = (map['type'] ?? contact.type) as String?;
    if (finalType != null) {
      try {
        map['contact_type'] = mapContactType(finalType);
      } catch (_) {
        map['contact_type'] = 'OTRO';
      }
    }
    // Normalize phone to avoid server-side validation errors (trim + max 20)
    if (map.containsKey('phone') && map['phone'] != null) {
      final p = map['phone'].toString().trim();
      map['phone'] = p.length > 20 ? p.substring(0, 20) : p;
    }
    final rawMap = Map<String, dynamic>.from(map);
    if (imagePath != null && imagePath.isNotEmpty) {
      map['image'] = await MultipartFile.fromFile(imagePath);
      rawMap['image'] = imagePath;
    }
    final payload = FormData.fromMap(map);
    try {
      // ignore: avoid_print
      print('ContactsDataSource.updateContact PUT -> ${_dio.options.baseUrl}${ApiConstants.contactDetail(id)}');
      // ignore: avoid_print
      print('Payload keys: ${payload.fields.map((f) => f.key).toList()}');
        final res = await _dio.put(ApiConstants.contactDetail(id),
          data: payload, options: Options(extra: {'_disable_retry': true, '_form_map_raw': rawMap}));
      return ContactModel.fromJson(res.data as Map<String, dynamic>);
    } catch (e) {
      final de = e as dynamic;
      // ignore: avoid_print
      print('Contacts update error: status=${de?.response?.statusCode} body=${de?.response?.data} error=${de?.message ?? de}');
      rethrow;
    }
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
    // Normalize phone before sending
    final p = phone.trim();
    final normPhone = p.length > 20 ? p.substring(0, 20) : p;
    final Map<String, dynamic> map = {
      'phone': normPhone,
    };
    final rawMap = Map<String, dynamic>.from(map);
    if (imagePath != null && imagePath.isNotEmpty) {
      map['image'] = await MultipartFile.fromFile(imagePath);
      rawMap['image'] = imagePath;
    }
    final payload = FormData.fromMap(map);
    final res = await _dio.put(ApiConstants.contactDetail(id),
      data: payload, options: Options(extra: {'_disable_retry': true, '_form_map_raw': rawMap}));
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

/// Optional local override used for optimistic updates. When non-null,
/// `contactsProvider` will return this list immediately until the override
/// is cleared.
final contactsOverrideProvider = StateProvider<List<ContactModel>?>(
  (ref) => null,
);

final contactsProvider = FutureProvider<List<ContactModel>>((ref) async {
  final override = ref.watch(contactsOverrideProvider);
  if (override != null) return override;
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
    final prevAsync = _ref.read(contactsProvider);
    final prev = prevAsync.asData?.value ?? [];

    // optimistic: insert a temporary contact immediately
    final tempId = -DateTime.now().millisecondsSinceEpoch;
    final tempContact = ContactModel(
      id: tempId,
      name: name,
      phone: phone,
      email: email,
      type: type,
      description: description,
      imageUrl: imageUrl,
      categoryId: categoryId,
    );
    _ref.read(contactsOverrideProvider.notifier).state = [tempContact, ...prev];

    try {
      final created = await ds.createContact(tempContact, imagePath: imagePath);
      // replace temp with created
      final replaced = _ref.read(contactsOverrideProvider)!
          .map((c) => c.id == tempId ? created : c)
          .toList();
      _ref.read(contactsOverrideProvider.notifier).state = replaced;
      // clear override and refresh from server to ensure consistency
      _ref.read(contactsOverrideProvider.notifier).state = null;
      _ref.invalidate(contactsProvider);
    } catch (e) {
      // rollback optimistic update
      _ref.read(contactsOverrideProvider.notifier).state = null;
      rethrow;
    }
  }

  Future<void> updateOwnContact({
    required int contactId,
    required String phone,
    String? imagePath,
  }) async {
    final ds = _ref.read(contactsDataSourceProvider);
    final prevAsync = _ref.read(contactsProvider);
    final prev = prevAsync.asData?.value ?? [];
    final idx = prev.indexWhere((c) => c.id == contactId);
    if (idx == -1) {
      // no local data to update optimistically; fallback to server call
      await ds.updateMyContact(id: contactId, phone: phone, imagePath: imagePath);
      _ref.invalidate(contactsProvider);
      return;
    }

    final orig = prev[idx];
    final updatedLocal = ContactModel(
      id: orig.id,
      name: orig.name,
      phone: phone,
      email: orig.email,
      type: orig.type,
      description: orig.description,
      imageUrl: orig.imageUrl,
      categoryId: orig.categoryId,
      categoryName: orig.categoryName,
      ownerId: orig.ownerId,
      approvalStatus: orig.approvalStatus,
      rejectionReason: orig.rejectionReason,
    );

    final newList = [...prev];
    newList[idx] = updatedLocal;
    _ref.read(contactsOverrideProvider.notifier).state = newList;

    try {
      await ds.updateMyContact(id: contactId, phone: phone, imagePath: imagePath);
      _ref.read(contactsOverrideProvider.notifier).state = null;
      _ref.invalidate(contactsProvider);
    } catch (e) {
      _ref.read(contactsOverrideProvider.notifier).state = null;
      rethrow;
    }
  }
}
