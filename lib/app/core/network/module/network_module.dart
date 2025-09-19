import 'dart:async';

import 'package:dio/dio.dart';
import 'package:disciple/app/config/app_logger.dart';
import 'package:disciple/app/core/network/api_path.dart';
import 'package:disciple/app/core/network/error/api_error.dart';
import 'package:disciple/features/authentication/services/keycloak_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

final _logger = getLogger('Networkmodule');

/// ✅ Provides a configured Dio instance
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiPath.baseUrl,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 20),
    ),
  );

  // 🔐 Interceptors
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Inject auth token if available
        final token = _getAccessToken(ref);

        if (token != null) {
          options.headers["authorization"] = "Bearer $token";
        }
        options.headers["Content-Type"] = "application/json";
        return handler.next(options);
      },
      onResponse: (response, handler) => handler.resolve(
        Response(
          requestOptions: response.requestOptions,
          data: response.data,
          statusCode: response.statusCode,
        ),
      ),
      onError: (e, handler) async {
        final apiError = ApiError.fromDio(e);

        // 🟡 Handle expired token (401 Unauthorized)
        if (apiError.statusCode == 401 && !_isRefreshing) {
          _isRefreshing = true;
          try {
            final newToken = _refreshToken(ref);
            e.requestOptions.headers["authorization"] = "Bearer $newToken";
            e.requestOptions.headers["Content-Type"] = "application/json";

            // retry the original request with new token
            final cloned = await dio.fetch(e.requestOptions);
            _isRefreshing = false;
            return handler.resolve(cloned);
          } catch (_) {
            _isRefreshing = false;
            // let it fall through (user must re-login)
            return handler.reject(
              DioException(
                requestOptions: e.requestOptions,
                message: apiError.message,
                response: e.response,
                error: apiError,
              ),
            );
          }
        } else {
          _isRefreshing = false;
        }

        return handler.reject(
          DioException(
            requestOptions: e.requestOptions,
            message: apiError.message,
            response: e.response,
            error: apiError,
          ),
        );
      },
    ),
  );

  // 📝 Logging (only in debug mode)
  if (kDebugMode) {
    dio.interceptors.add(
      PrettyDioLogger(requestHeader: true, requestBody: true),
    );
  }

  return dio;
});

/// --- 🔐 Token management helpers ---
/// These can be adapted to use secure storage, Hive, SharedPrefs, etc.
bool _isRefreshing = false;

String? _getAccessToken(Ref ref) =>
    ref.read(keycloakServiceProvider).value?.accessToken;

String? _getRefreshToken(Ref ref) =>
    ref.read(keycloakServiceProvider).value?.refreshToken;

/// TODO: Research how refresh token works with keycloak
Future<String?> _refreshToken(Ref ref) async {
  final dio = Dio(BaseOptions(baseUrl: ApiPath.baseUrl));
  final refreshToken = _getRefreshToken(ref);

  if (refreshToken == null) return null;

  try {
    final response = await dio.post(
      ApiPath.refreshToken,
      data: {"refresh_token": refreshToken},
    );

    if (response.statusCode == 200) {
      final newToken = response.data;
      return newToken;
    }
  } on DioException catch (e) {
    _logger.e("❌ Token refresh failed: ${e.message}");
  }
  return null;
}
