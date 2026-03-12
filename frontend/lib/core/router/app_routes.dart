class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';

  // Shell de cliente
  static const String store = '/client/store';
  static const String services = '/client/services';
  static const String deliveries = '/client/deliveries';
  static const String contacts = '/client/contacts';
  static const String orderHistory = '/client/orders';
  static const String orderConfirm = '/client/order-confirm';

  // Shell de prestador
  static const String providerDashboard = '/provider/dashboard';
  static const String registerProvider = '/provider/register';

  // Shell de domiciliario
  static const String delivererDashboard = '/deliverer/dashboard';
  static const String myDeliveries = '/deliverer/my-deliveries';
  static const String financialRecords = '/deliverer/records';

  // Shell de admin
  static const String adminDashboard = '/admin/dashboard';
  static const String manageUsers = '/admin/users';
  static const String manageProviders = '/admin/providers';
  static const String manageStore = '/admin/store';
  static const String manageContacts = '/admin/contacts';
  static const String reports = '/admin/reports';
}
