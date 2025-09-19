import 'package:disciple/app/common/app_strings.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:disciple/app/core/constants/app_constants.dart';

enum AppEnv { development, production, test }

class AppConfig {
  static final String _notFound = AppString.notFound;

  static late AppEnv _appEnv;

  static void setAppEnv(AppEnv env) => _appEnv = env;

  static bool get _isDevelopment => _appEnv == AppEnv.development;

  static bool get _isTest => _appEnv == AppEnv.test;

  static bool get isProduction => _appEnv == AppEnv.production;

  static String get fileName => _getFileName();

  static bool get isDebug => _appEnv == AppEnv.development;

  static String get apiUrl =>
      dotenv.env[AppConstants.apiUrl] ?? '${AppConstants.apiUrl} $_notFound';

  static String get appName =>
      dotenv.env[AppConstants.appName] ?? '${AppConstants.appName} $_notFound';

  static String get keycloakClientId =>
      dotenv.env[AppConstants.keycloakClientId] ??
      '${AppConstants.keycloakClientId} $_notFound';

  static String get keycloakClientRealm =>
      dotenv.env[AppConstants.keycloakClientRealm] ??
      '${AppConstants.keycloakClientRealm} $_notFound';

  static String get keycloakBundleIdentifier =>
      dotenv.env[AppConstants.keycloakBundleIdentifier] ??
      '${AppConstants.keycloakBundleIdentifier} $_notFound';

  static String get keycloakFrontendUrl =>
      dotenv.env[AppConstants.keycloakFrontendUrl] ??
      '${AppConstants.keycloakFrontendUrl} $_notFound';

  static String _getFileName() {
    if (_isDevelopment) return AppConstants.developmentEnv;
    if (_isTest) return AppConstants.testEnv;
    return AppConstants.liveEnv;
  }
}
