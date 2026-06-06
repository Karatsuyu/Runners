import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/storage/hive_cache_service.dart';

class ContactType {
  final String value;
  final String label;
  const ContactType({required this.value, required this.label});

  Map<String, String> toMap() => {'value': value, 'label': label};

  factory ContactType.fromMap(Map<String, dynamic> m) => ContactType(value: m['value'] as String, label: m['label'] as String);
}

class ContactTypesNotifier extends StateNotifier<List<ContactType>> {
  ContactTypesNotifier() : super([]) {
    _load();
  }

  Future<void> _load() async {
    final cache = HiveCacheService();
    final stored = cache.getContactTypes();
    if (stored != null && stored.isNotEmpty) {
      state = stored.map((m) => ContactType.fromMap(m)).toList();
      return;
    }
    // defaults
    state = [
      const ContactType(value: 'professional', label: 'Profesional'),
      const ContactType(value: 'emergency', label: 'Emergencia'),
      const ContactType(value: 'commerce', label: 'Comercio'),
      const ContactType(value: 'servicio', label: 'Servicio'),
      const ContactType(value: 'contacto', label: 'Contacto'),
      const ContactType(value: 'other', label: 'Otro'),
    ];
    await cache.saveContactTypes(state.map((e) => e.toMap()).toList());
  }

  Future<void> add(String label) async {
    final value = _slugify(label);
    final item = ContactType(value: value, label: label);
    state = [...state, item];
    await HiveCacheService().saveContactTypes(state.map((e) => e.toMap()).toList());
  }

  Future<void> update(String value, String newLabel) async {
    state = state.map((e) => e.value == value ? ContactType(value: value, label: newLabel) : e).toList();
    await HiveCacheService().saveContactTypes(state.map((e) => e.toMap()).toList());
  }

  Future<void> remove(String value) async {
    state = state.where((e) => e.value != value).toList();
    await HiveCacheService().saveContactTypes(state.map((e) => e.toMap()).toList());
  }

  String _slugify(String s) => s.toLowerCase().replaceAll(RegExp(r"[^a-z0-9]+"), '_').replaceAll(RegExp(r"_+"), '_').trim();
} 

final contactTypesProvider = StateNotifierProvider<ContactTypesNotifier, List<ContactType>>((ref) => ContactTypesNotifier());
