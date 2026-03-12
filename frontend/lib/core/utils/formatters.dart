import 'package:intl/intl.dart';

class AppFormatters {
  static final NumberFormat _currencyCOP =
      NumberFormat.currency(locale: 'es_CO', symbol: '\$', decimalDigits: 0);

  static String currency(double amount) => _currencyCOP.format(amount);

  static String date(dynamic value) {
    if (value == null) return '';
    final dt = value is DateTime ? value : DateTime.tryParse(value.toString());
    if (dt == null) return value.toString();
    return DateFormat('dd/MM/yyyy', 'es').format(dt);
  }

  static String dateTime(dynamic value) {
    if (value == null) return '';
    final dt = value is DateTime ? value : DateTime.tryParse(value.toString());
    if (dt == null) return value.toString();
    return DateFormat('dd/MM/yyyy HH:mm', 'es').format(dt);
  }

  static String timeAgo(dynamic value) {
    if (value == null) return '';
    final dt = value is DateTime ? value : DateTime.tryParse(value.toString());
    if (dt == null) return '';
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'Ahora mismo';
    if (diff.inMinutes < 60) return 'Hace ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'Hace ${diff.inHours} h';
    return 'Hace ${diff.inDays} días';
  }
}
