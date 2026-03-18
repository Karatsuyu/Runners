import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';

class ApiConstants {
  static String get baseUrl {
    final defaultUrl = 'http://10.0.2.2:8000/api/v1';
    final rawBaseUrl =
        (kIsWeb ? dotenv.env['API_BASE_URL_WEB'] : null) ??
            dotenv.env['API_BASE_URL'] ??
            defaultUrl;

    // 10.0.2.2 is only valid inside Android emulator.
    if (kIsWeb && rawBaseUrl.contains('10.0.2.2')) {
      return rawBaseUrl.replaceFirst('10.0.2.2', 'localhost');
    }

    return rawBaseUrl;
  }

  // Auth
  static const String register = '/auth/register/';
  static const String login = '/auth/login/';
  static const String tokenRefresh = '/auth/token/refresh/';
  static const String logout = '/auth/logout/';
  static const String profile = '/auth/profile/';
  static const String users = '/auth/users/';
  static String toggleUserStatus(int id) => '/auth/users/$id/toggle-status/';

  // Store
  static const String categories = '/store/categories/';
  static const String commerces = '/store/commerces/';
  static String commerceDetail(int id) => '/store/commerces/$id/';
  static String commerceProducts(int id) => '/store/commerces/$id/products/';
  static const String orders = '/store/orders/';
  static const String createOrder = '/store/orders/create/';

  // Services
  static const String serviceCategories = '/services/categories/';
  static const String providers = '/services/providers/';
  static const String registerProvider = '/services/providers/register/';
  static const String providerStatus = '/services/providers/status/';
  static String approveProvider(int id) => '/services/providers/$id/approve/';
  static const String serviceRequests = '/services/requests/';
  static const String createServiceRequest = '/services/requests/create/';
  static const String myServiceRequests = '/services/requests/my-requests/';

  // Deliveries - flujo automatizado
  static const String deliverers = '/deliveries/deliverers/';
  static const String delivererStatus = '/deliveries/deliverers/status/';
  static const String deliveryRequests = '/deliveries/requests/';
  static const String createDeliveryRequest = '/deliveries/requests/create/';
  static String deliveryRequestDetail(int id) => '/deliveries/requests/$id/';
  static String assignDelivery(int id) => '/deliveries/requests/$id/assign/';
  static String completeDelivery(int id) => '/deliveries/requests/$id/complete/';
  static const String financialRecords = '/deliveries/records/';
  static const String myDeliveries = '/deliveries/requests/my-deliveries/';

  // Contacts (solo directorio, sin disponibilidad)
  static const String contacts = '/contacts/';
  static String contactDetail(int id) => '/contacts/$id/';

  // Provider profile
  static String providerDetail(int id) => '/services/providers/$id/';
  static const String myProviderProfile = '/services/providers/me/';

  // Deliverer profile
  static const String delivererProfile = '/deliveries/deliverers/me/';

  // Reports (admin)
  static const String dashboardReport = '/reports/dashboard/';
  static const String salesReport = '/reports/sales/';
  static const String deliverersReport = '/reports/deliverers/';
  static const String servicesReport = '/reports/services/';

  // Admin
  static const String manageProviders = '/services/providers/admin/';
  static const String manageCommerces = '/store/commerces/admin/';
  static const String manageProducts = '/store/products/admin/';
}
