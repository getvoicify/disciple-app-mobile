import 'dart:async';
import 'package:disciple/app/config/app_config.dart';
import 'package:disciple/app/config/app_logger.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keycloak_wrapper/keycloak_wrapper.dart';

final keycloakServiceProvider = FutureProvider<KeycloakService>(
  (ref) async => await KeycloakService.create(),
);

final authStatusProvider = StreamProvider<bool>((ref) async* {
  final service = await ref.watch(keycloakServiceProvider.future);
  yield* service.authenticationStream;
});

class KeycloakService {
  final KeycloakWrapper _keycloakWrapper;
  Timer? _refreshTimer;

  KeycloakService._(this._keycloakWrapper);

  static Future<KeycloakService> create() async {
    final keycloakConfig = KeycloakConfig(
      bundleIdentifier: AppConfig.keycloakBundleIdentifier,
      clientId: AppConfig.keycloakClientId,
      frontendUrl: AppConfig.keycloakFrontendUrl,
      realm: AppConfig.keycloakClientRealm,
    );

    final wrapper = KeycloakWrapper(config: keycloakConfig);
    await wrapper.initialize();

    final service = KeycloakService._(wrapper);
    // 👇 start proactive refresh
    await service._scheduleTokenRefresh();
    return service;
  }

  String? get accessToken => _keycloakWrapper.accessToken;
  String? get refreshToken => _keycloakWrapper.refreshToken;

  bool get isAuthenticated => accessToken != null;

  Stream<bool> get authenticationStream =>
      _keycloakWrapper.authenticationStream;

  Future<void> exchangeTokens([Duration? duration]) async {
    await _keycloakWrapper.exchangeTokens(duration);
    // 👇 reschedule after refresh
    _scheduleTokenRefresh();
  }

  Future<bool> login() async {
    final success = await _keycloakWrapper.login();

    if (success) {
      final token = _keycloakWrapper.accessToken;
      if (kDebugMode) await Clipboard.setData(ClipboardData(text: token ?? ''));

      _scheduleTokenRefresh();
    }
    return success;
  }

  Future<void> logout() async {
    await _keycloakWrapper.logout();
    _refreshTimer?.cancel();
    _refreshTimer = null;
  }

  Future<void> getUserInfo() async {}

  set onError(Function(String, Object, StackTrace) onError) {
    _keycloakWrapper.onError = onError;
  }

  /// --- 🔄 Token Refresh Scheduling ---
  Future<void> _scheduleTokenRefresh() async {
    _refreshTimer?.cancel();

    final expiry =
        _keycloakWrapper.tokenResponse?.accessTokenExpirationDateTime;
    if (expiry == null) return;

    final now = DateTime.now();
    // Refresh 1 minute before expiry
    final refreshAt = expiry.subtract(const Duration(minutes: 1));
    final delay = refreshAt.difference(now);

    if (delay.isNegative) {
      // Already expired, try immediate refresh
      await exchangeTokens();
      return;
    }

    getLogger(
      'KeycloakService',
    ).i("⏰ Scheduling token refresh in ${delay.inSeconds} seconds");

    _refreshTimer = Timer(delay, () async {
      getLogger('KeycloakService').i("🔄 Auto refreshing token...");
      await exchangeTokens();
    });
  }
}
