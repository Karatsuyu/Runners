import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Servicio de notificaciones locales para la app Runners.
///
/// Inicializar en main() antes de runApp():
/// ```dart
/// await NotificationsService.init();
/// ```
///
/// Uso:
/// ```dart
/// await NotificationsService.showSuccess('Pedido creado', 'Tu pedido #123 fue enviado.');
/// await NotificationsService.showInfo('Nuevo servicio', 'Un prestador aceptó tu solicitud.');
/// ```
class NotificationsService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static bool _initialized = false;

  // ── IDs de canales de notificación ────────────────────────────────────────
  static const String _channelIdOrders = 'runners_orders';
  static const String _channelIdServices = 'runners_services';
  static const String _channelIdDeliveries = 'runners_deliveries';
  static const String _channelIdGeneral = 'runners_general';

  // ── Inicialización ────────────────────────────────────────────────────────

  static Future<void> init() async {
    if (_initialized) return;

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    // Crear canales Android (requerido desde Android 8.0+)
    await _createAndroidChannels();

    _initialized = true;
  }

  static Future<void> _createAndroidChannels() async {
    final androidPlugin =
        _plugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin == null) return;

    await Future.wait([
      androidPlugin.createNotificationChannel(const AndroidNotificationChannel(
        _channelIdOrders,
        'Pedidos',
        description: 'Notificaciones de estado de pedidos en la tienda.',
        importance: Importance.high,
      )),
      androidPlugin.createNotificationChannel(const AndroidNotificationChannel(
        _channelIdServices,
        'Servicios',
        description: 'Notificaciones de solicitudes y servicios.',
        importance: Importance.high,
      )),
      androidPlugin.createNotificationChannel(const AndroidNotificationChannel(
        _channelIdDeliveries,
        'Domicilios',
        description: 'Notificaciones de domicilios y entregas.',
        importance: Importance.high,
      )),
      androidPlugin.createNotificationChannel(const AndroidNotificationChannel(
        _channelIdGeneral,
        'General',
        description: 'Notificaciones generales de Runners.',
        importance: Importance.defaultImportance,
      )),
    ]);
  }

  static void _onNotificationTap(NotificationResponse response) {
    // Manejar tap en notificación si es necesario.
    // payload contiene la ruta a la que navegar.
  }

  // ── Métodos de notificación ───────────────────────────────────────────────

  /// Notificación de éxito (ej: pedido creado).
  static Future<void> showSuccess(
    String title,
    String body, {
    String? payload,
    int id = 0,
  }) async {
    await _show(
      id: id,
      title: title,
      body: body,
      channelId: _channelIdGeneral,
      channelName: 'General',
      payload: payload,
    );
  }

  /// Notificación de pedido.
  static Future<void> showOrderNotification({
    required int orderId,
    required String status,
  }) async {
    final statusLabel = _orderStatusLabel(status);
    await _show(
      id: orderId,
      title: 'Pedido #$orderId',
      body: 'Tu pedido está: $statusLabel',
      channelId: _channelIdOrders,
      channelName: 'Pedidos',
      payload: '/client/orders',
    );
  }

  /// Notificación de nuevo servicio solicitado (para prestadores).
  static Future<void> showNewServiceRequest({
    required int requestId,
    required String clientName,
  }) async {
    await _show(
      id: requestId,
      title: '¡Nueva solicitud de servicio!',
      body: '$clientName solicita tus servicios.',
      channelId: _channelIdServices,
      channelName: 'Servicios',
      payload: '/provider/dashboard',
    );
  }

  /// Notificación de domicilio asignado (para domiciliarios).
  static Future<void> showDeliveryAssigned({
    required int deliveryId,
    required String address,
  }) async {
    await _show(
      id: deliveryId,
      title: 'Nuevo domicilio asignado',
      body: 'Destino: $address',
      channelId: _channelIdDeliveries,
      channelName: 'Domicilios',
      payload: '/deliverer/dashboard',
    );
  }

  /// Notificación de aprobación de prestador (para prestadores).
  static Future<void> showProviderApproved(bool approved) async {
    await _show(
      id: 900,
      title: approved ? '¡Perfil aprobado!' : 'Perfil no aprobado',
      body: approved
          ? 'Tu perfil de prestador fue aprobado. ¡Ya puedes recibir solicitudes!'
          : 'Tu perfil de prestador no fue aprobado. Revisa los comentarios del administrador.',
      channelId: _channelIdServices,
      channelName: 'Servicios',
      payload: '/provider/dashboard',
    );
  }

  /// Notificación informativa general.
  static Future<void> showInfo(
    String title,
    String body, {
    String? payload,
  }) async {
    await _show(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: title,
      body: body,
      channelId: _channelIdGeneral,
      channelName: 'General',
      payload: payload,
    );
  }

  // ── Cancelar notificaciones ───────────────────────────────────────────────

  static Future<void> cancelAll() => _plugin.cancelAll();
  static Future<void> cancel(int id) => _plugin.cancel(id);

  // ── Privado ───────────────────────────────────────────────────────────────

  static Future<void> _show({
    required int id,
    required String title,
    required String body,
    required String channelId,
    required String channelName,
    String? payload,
  }) async {
    if (!_initialized) await init();

    final androidDetails = AndroidNotificationDetails(
      channelId,
      channelName,
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    final details = NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _plugin.show(id, title, body, details, payload: payload);
  }

  static String _orderStatusLabel(String status) {
    switch (status.toUpperCase()) {
      case 'PENDIENTE': return 'Pendiente de confirmación';
      case 'CONFIRMADO': return 'Confirmado';
      case 'EN_PROCESO': return 'En camino';
      case 'ENTREGADO': return 'Entregado ✓';
      case 'CANCELADO': return 'Cancelado';
      default: return status;
    }
  }
}
