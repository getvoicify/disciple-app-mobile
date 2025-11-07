import 'dart:async';
import 'dart:io';

import 'package:disciple/app/config/app_config.dart';
import 'package:disciple/app/config/app_logger.dart';
import 'package:disciple/app/core/manager/model/user.dart';
import 'package:disciple/app/core/routes/app_router.gr.dart';
import 'package:disciple/app/core/routes/page_navigator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keycloak_wrapper/keycloak_wrapper.dart';

final keycloakManagerProvider = FutureProvider<KeycloakManager>(
  (ref) async => await KeycloakManager.create(),
);

class KeycloakManager {
  final KeycloakWrapper _keycloakWrapper;
  Timer? _refreshTimer;

  KeycloakManager._(this._keycloakWrapper);

  static Future<KeycloakManager> create() async {
    final keycloakConfig = KeycloakConfig(
      bundleIdentifier: AppConfig.keycloakBundleIdentifier,
      clientId: AppConfig.keycloakClientId,
      frontendUrl: AppConfig.keycloakFrontendUrl,
      realm: AppConfig.keycloakClientRealm,
    );

    final wrapper = KeycloakWrapper(config: keycloakConfig);
    await wrapper.initialize();

    final service = KeycloakManager._(wrapper);

    wrapper.onError = (message, error, stackTrace) async {
      if (message == 'Failed to fetch user info.') {
        await service._logout();
      }
    };
    // 👇 get user info and start proactive refresh
    await Future.wait([
      service._getUserInfo(),
      service._scheduleTokenRefresh(),
    ]);
    return service;
  }

  String? get accessToken => _keycloakWrapper.accessToken;
  String? get refreshToken => _keycloakWrapper.refreshToken;

  bool get isAuthenticated => accessToken != null;

  User? _user;

  User? get user => _user;

  Stream<bool> get authenticationStream =>
      _keycloakWrapper.authenticationStream;

  Future<void> exchangeTokens([Duration? duration]) async {
    await _keycloakWrapper.exchangeTokens(duration);
    // 👇 Save the new token after refresh (for debugging)
    await _saveTokenToFile(_keycloakWrapper.accessToken);

    // 👇 Reschedule after refresh
    _scheduleTokenRefresh();
  }

  Future<bool> login() async {
    final success = await _keycloakWrapper.login();

    if (success) {
      final token = _keycloakWrapper.accessToken;
      await _saveTokenToFile(token);

      _scheduleTokenRefresh();
    }
    return success;
  }

  Future<void> _saveTokenToFile(String? token) async {
    if (kDebugMode) {
      try {
        final file = File('/Users/mac/Documents/disciple/tokens.txt');

        await file.writeAsString(token ?? '');

        debugPrint('✅ Token saved to: ${file.path}');
      } catch (e) {
        debugPrint('❌ Failed to save token: $e');
      }
    }
  }

  Future<void> _logout() async {
    await _keycloakWrapper.logout();
    _refreshTimer?.cancel();
    _refreshTimer = null;

    // PageNavigator.replace(const HomeboardingRoute());
  }

  Future<void> _getUserInfo() async {
    final userInfo = await _keycloakWrapper.getUserInfo();
    if (userInfo != null) _user = User.fromJson(userInfo);
  }

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
