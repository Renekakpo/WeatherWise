import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConnectivityService {
  ConnectivityService({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;

  Future<bool> isInternetAvailable() async {
    final results = await _connectivity.checkConnectivity();
    return results.contains(ConnectivityResult.mobile) ||
        results.contains(ConnectivityResult.wifi);
  }

  Stream<List<ConnectivityResult>> get connectivityStream =>
      _connectivity.onConnectivityChanged;
}

final connectivityServiceProvider = Provider<ConnectivityService>((_) {
  return ConnectivityService();
});

final connectivityStreamProvider =
    StreamProvider<List<ConnectivityResult>>((ref) {
  return ref.watch(connectivityServiceProvider).connectivityStream;
});
