import 'dart:async';
import 'dart:io';

import 'package:disciple/app/config/app_logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

enum NetworkStatus { online, offline }

// network_providers.dart
final connectivityManagerProvider =
    StateNotifierProvider<ConnectivityManager, NetworkStatus>(
      (ref) => ConnectivityManager(),
    );

// Provider to get the network manager instance
final connectivityManagerInstanceProvider = Provider<ConnectivityManager>(
  (ref) => ref.watch(connectivityManagerProvider.notifier),
);

class ConnectivityManager extends StateNotifier<NetworkStatus> {
  final logger = getLogger('ConnectivityManager');

  final Duration checkInterval;
  final Uri testUri;

  Timer? _timer;
  final HttpClient _httpClient;

  // Add this controller to broadcast status changes
  final _statusController = StreamController<NetworkStatus>.broadcast();
  Stream<NetworkStatus> get onStatusChanged => _statusController.stream;

  ConnectivityManager({
    this.checkInterval = const Duration(seconds: 5),
    Uri? testUri,
  }) : testUri = testUri ?? Uri.https('www.google.com', '/'),
       _httpClient = HttpClient(),
       super(NetworkStatus.offline) {
    _httpClient.connectionTimeout = const Duration(seconds: 3);
    unawaited(start());
  }

  /// Public getter to check current status
  bool get isOnline => state == NetworkStatus.online;

  /// Start periodic check
  Future<void> start() async {
    // Prevent multiple timers
    _stop();
    _timer = Timer.periodic(checkInterval, (_) async {
      await _updateStatus();
    });
    // Check status immediately on start
    await _updateStatus();
  }

  /// Stop checking
  void _stop() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> _updateStatus() async {
    try {
      final isNowOnline = await _checkInternetConnection();
      state = isNowOnline ? NetworkStatus.online : NetworkStatus.offline;

      _statusController.add(state); // Notify stream listeners
    } catch (e) {
      logger.e('Network check failed: $e');
      state = NetworkStatus.offline;
      _statusController.add(NetworkStatus.offline); // Notify stream listeners
    }
  }

  /// Manual internet check (internal)
  Future<bool> _checkInternetConnection() async {
    try {
      final request = await _httpClient.getUrl(testUri);
      final response = await request.close();
      return response.statusCode == HttpStatus.ok;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<void> dispose() async {
    // Important: close the controller
    await _statusController.close();
    _stop();
    _timer?.cancel();
    _httpClient.close();
    super.dispose();
  }
}
