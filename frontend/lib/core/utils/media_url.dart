import '../constants/api_constants.dart';

String? resolveMediaUrl(String? url) {
  if (url == null || url.isEmpty) return null;
  if (url.startsWith('http')) return url;

  final root = ApiConstants.baseUrl.replaceFirst('/api/v1', '');
  if (url.startsWith('/')) return '$root$url';
  return '$root/$url';
}