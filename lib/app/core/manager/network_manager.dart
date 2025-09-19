import 'dart:async';
import 'dart:io';

import 'package:disciple/app/config/app_logger.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

enum NetworkStatus { online, offline }

final networkManagerProvider =
    StateNotifierProvider<NetworkManager, NetworkStatus>((ref) {
      final manager = NetworkManager();
      ref.onDispose(() => manager.dispose());
      return manager;
    });

final isOnlineProvider = Provider<bool>((ref) {
  final status = ref.watch(networkManagerProvider);
  return status == NetworkStatus.online;
});

class NetworkManager extends StateNotifier<NetworkStatus> {
  final logger = getLogger('NetworkManager');

  final Duration checkInterval;
  final Uri testUri;

  Timer? _timer;
  final HttpClient _httpClient;

  NetworkManager({
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
    if (kReleaseMode) {
      _timer = Timer.periodic(checkInterval, (_) => _updateStatus());
    }
    // Check status immediately on start
    await _updateStatus();
  }

  /// Stop checking
  void _stop() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> _updateStatus() async {
    final isNowOnline = await _checkInternetConnection();
    final newStatus = isNowOnline
        ? NetworkStatus.online
        : NetworkStatus.offline;

    if (state != newStatus) {
      state = newStatus;
    }

    logger.i('Network status: $state');
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
  void dispose() {
    _stop();
    _httpClient.close(force: true);
    super.dispose();
  }
}
