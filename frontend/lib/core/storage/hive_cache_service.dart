import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';

/// Servicio de caché local usando Hive.
/// Permite guardar listas de datos JSON para modo offline.
///
/// Uso en main.dart (inicializar antes de runApp):
/// ```dart
/// await HiveCacheService.init();
/// ```
///
/// Uso en providers:
/// ```dart
/// final cache = HiveCacheService();
/// await cache.saveContacts(contacts);
/// final cached = cache.getContacts();
/// ```
class HiveCacheService {
  static const String _contactsBox = 'contacts_cache';
  static const String _contactsKey = 'contacts_list';
  static const String _contactsTimestampKey = 'contacts_timestamp';

  static const String _categoriesBox = 'categories_cache';
  static const String _categoriesKey = 'categories_list';

  static const String _commercesBox = 'commerces_cache';
  static const String _commercesKey = 'commerces_list';

  /// Duración máxima del caché antes de considerarse expirado.
  static const Duration _cacheExpiry = Duration(hours: 6);

  // ── Inicialización ────────────────────────────────────────────────────────

  /// Inicializar Hive. Llamar una sola vez en main() antes de runApp().
  static Future<void> init() async {
    await Hive.initFlutter();
    await Future.wait([
      Hive.openBox<String>(_contactsBox),
      Hive.openBox<String>(_categoriesBox),
      Hive.openBox<String>(_commercesBox),
    ]);
  }

  // ── Contactos ─────────────────────────────────────────────────────────────

  /// Guarda la lista de contactos en caché.
  Future<void> saveContacts(List<Map<String, dynamic>> contacts) async {
    final box = Hive.box<String>(_contactsBox);
    await box.put(_contactsKey, jsonEncode(contacts));
    await box.put(_contactsTimestampKey, DateTime.now().toIso8601String());
  }

  /// Obtiene los contactos del caché. Devuelve `null` si el caché expiró o no existe.
  List<Map<String, dynamic>>? getContacts({bool ignoreExpiry = false}) {
    final box = Hive.box<String>(_contactsBox);
    final json = box.get(_contactsKey);
    if (json == null) return null;

    if (!ignoreExpiry && _isExpired(_contactsBox)) return null;

    final decoded = jsonDecode(json) as List;
    return decoded.cast<Map<String, dynamic>>();
  }

  /// Verifica si hay contactos en caché (expirados o no).
  bool get hasContactsCache {
    final box = Hive.box<String>(_contactsBox);
    return box.get(_contactsKey) != null;
  }

  /// Obtiene contactos del caché ignorando expiración (para modo avión).
  List<Map<String, dynamic>>? getContactsOffline() => getContacts(ignoreExpiry: true);

  // ── Categorías de tienda ──────────────────────────────────────────────────

  Future<void> saveCategories(List<Map<String, dynamic>> categories) async {
    final box = Hive.box<String>(_categoriesBox);
    await box.put(_categoriesKey, jsonEncode(categories));
    await box.put('${_categoriesKey}_ts', DateTime.now().toIso8601String());
  }

  List<Map<String, dynamic>>? getCategories({bool ignoreExpiry = false}) {
    final box = Hive.box<String>(_categoriesBox);
    final json = box.get(_categoriesKey);
    if (json == null) return null;
    if (!ignoreExpiry && _isExpiredBox(_categoriesBox, '${_categoriesKey}_ts')) return null;
    final decoded = jsonDecode(json) as List;
    return decoded.cast<Map<String, dynamic>>();
  }

  // ── Comercios ─────────────────────────────────────────────────────────────

  Future<void> saveCommerces(List<Map<String, dynamic>> commerces) async {
    final box = Hive.box<String>(_commercesBox);
    await box.put(_commercesKey, jsonEncode(commerces));
    await box.put('${_commercesKey}_ts', DateTime.now().toIso8601String());
  }

  List<Map<String, dynamic>>? getCommerces({bool ignoreExpiry = false}) {
    final box = Hive.box<String>(_commercesBox);
    final json = box.get(_commercesKey);
    if (json == null) return null;
    if (!ignoreExpiry && _isExpiredBox(_commercesBox, '${_commercesKey}_ts')) return null;
    final decoded = jsonDecode(json) as List;
    return decoded.cast<Map<String, dynamic>>();
  }

  // ── Utilidades ────────────────────────────────────────────────────────────

  bool _isExpired(String boxName) {
    return _isExpiredBox(boxName, _contactsTimestampKey);
  }

  bool _isExpiredBox(String boxName, String timestampKey) {
    final box = Hive.box<String>(boxName);
    final tsStr = box.get(timestampKey);
    if (tsStr == null) return true;
    final ts = DateTime.tryParse(tsStr);
    if (ts == null) return true;
    return DateTime.now().difference(ts) > _cacheExpiry;
  }

  /// Limpia todo el caché.
  Future<void> clearAll() async {
    await Future.wait([
      Hive.box<String>(_contactsBox).clear(),
      Hive.box<String>(_categoriesBox).clear(),
      Hive.box<String>(_commercesBox).clear(),
    ]);
  }

  /// Limpia solo el caché de contactos.
  Future<void> clearContacts() async {
    await Hive.box<String>(_contactsBox).clear();
  }
}
