import 'package:connectivity_plus/connectivity_plus.dart';

/// Servicio para verificar el estado de la conexión a internet.
/// Usa el paquete `connectivity_plus`.
///
/// Uso en providers:
/// ```dart
/// final networkInfo = ref.read(networkInfoProvider);
/// if (!await networkInfo.isConnected) {
///   // mostrar error de sin conexión
/// }
/// ```
abstract class NetworkInfo {
  Future<bool> get isConnected;
  Stream<bool> get onConnectivityChanged;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity _connectivity;

  NetworkInfoImpl(this._connectivity);

  @override
  Future<bool> get isConnected async {
    final results = await _connectivity.checkConnectivity();
    return _hasConnection(results);
  }

  @override
  Stream<bool> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged.map(_hasConnection);
  }

  bool _hasConnection(List<ConnectivityResult> results) {
    return results.any((r) =>
        r == ConnectivityResult.mobile ||
        r == ConnectivityResult.wifi ||
        r == ConnectivityResult.ethernet ||
        r == ConnectivityResult.vpn);
  }
}
