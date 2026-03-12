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

  const ContactModel({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    required this.type,
    this.description,
  });

  factory ContactModel.fromJson(Map<String, dynamic> j) => ContactModel(
        id: j['id'] as int,
        name: j['name'] as String? ?? '',
        phone: j['phone'] as String? ?? '',
        email: j['email'] as String?,
        type: j['type'] as String? ?? 'professional',
        description: j['description'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'phone': phone,
        if (email != null) 'email': email,
        'type': type,
        if (description != null) 'description': description,
      };

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

  Future<ContactModel> createContact(ContactModel contact) async {
    final res =
        await _dio.post(ApiConstants.contacts, data: contact.toJson());
    return ContactModel.fromJson(res.data as Map<String, dynamic>);
  }

  Future<ContactModel> updateContact(int id, ContactModel contact) async {
    final res = await _dio.put(
        ApiConstants.contactDetail(id), data: contact.toJson());
    return ContactModel.fromJson(res.data as Map<String, dynamic>);
  }

  Future<void> deleteContact(int id) async {
    await _dio.delete(ApiConstants.contactDetail(id));
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
    rethrow;
  }
});
