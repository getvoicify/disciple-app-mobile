import 'package:disciple/app/config/app_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keycloak_wrapper/keycloak_wrapper.dart';

final keycloakServiceProvider = FutureProvider<KeycloakService>(
  (ref) async => await KeycloakService.create(),
);

class KeycloakService {
  final KeycloakWrapper _keycloakWrapper;

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

    return KeycloakService._(wrapper);
  }

  String? get accessToken => _keycloakWrapper.accessToken;
  String? get refreshToken => _keycloakWrapper.refreshToken;

  bool get isAuthenticated => accessToken != null;

  Stream<bool> get authenticationStream =>
      _keycloakWrapper.authenticationStream;

  Future<bool> login() async => await _keycloakWrapper.login();

  Future<void> logout() async => await _keycloakWrapper.logout();

  Future<Map<String, dynamic>?> getUserInfo() async =>
      await _keycloakWrapper.getUserInfo();

  set onError(Function(String, Object, StackTrace) onError) {
    _keycloakWrapper.onError = onError;
  }
}
