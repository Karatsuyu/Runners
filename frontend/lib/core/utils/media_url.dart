import '../constants/api_constants.dart';

String? resolveMediaUrl(String? url) {
  if (url == null || url.isEmpty) return null;
  if (url.startsWith('http')) return url;

  final root = ApiConstants.baseUrl.replaceFirst('/api/v1', '');
  String full = url.startsWith('/') ? '$root$url' : '$root/$url';
  // Add cache-buster for menu files so clients see updated uploads immediately
  if (full.contains('store/menus/')) {
    final sep = full.contains('?') ? '&' : '?';
    full = '$full${sep}t=${DateTime.now().millisecondsSinceEpoch}';
  }
  return full;
}