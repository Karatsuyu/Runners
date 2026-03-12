import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'core/storage/hive_cache_service.dart';
import 'core/services/notifications_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Variables de entorno
  await dotenv.load(fileName: '.env');

  // Cache local offline (Hive)
  await HiveCacheService.init();

  // Notificaciones locales
  await NotificationsService.init();

  runApp(const ProviderScope(child: RunnersApp()));
}