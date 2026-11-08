import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum NetworkStatus { online, offline }

class ConnectivityService {
  ConnectivityService({Connectivity? connectivity})
    : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;

  /// Stream of network status updates.
  Stream<NetworkStatus> get statusStream {
    return _connectivity.onConnectivityChanged.map(_mapResultsToStatus);
  }

  /// One-shot check for network status.
  Future<NetworkStatus> checkStatus() async {
    final results = await _connectivity.checkConnectivity();
    return _mapResultsToStatus(results);
  }

  /// Whether device currently has an active network connection.
  Future<bool> get isConnected async {
    final status = await checkStatus();
    return status == NetworkStatus.online;
  }

  NetworkStatus _mapResultsToStatus(List<ConnectivityResult> results) {
    if (results.isEmpty || results.contains(ConnectivityResult.none)) {
      return NetworkStatus.offline;
    }
    return NetworkStatus.online;
  }
}

final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  return ConnectivityService();
});

/// Riverpod stream provider for real-time network connectivity.
/// Offline-first note: Core memory operations must never block on this provider.
final connectivityStreamProvider = StreamProvider<NetworkStatus>((ref) {
  final service = ref.watch(connectivityServiceProvider);
  return service.statusStream;
});
