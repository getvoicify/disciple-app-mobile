import 'dart:async';

import 'package:dio/dio.dart';
import 'package:disciple/app/core/network/error/api_error.dart';
import 'package:disciple/features/authentication/services/keycloak_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

/// ✅ Provides a configured Dio instance
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
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
        if (apiError.statusCode == 401) {
          try {
            final newToken = await _refreshToken(ref);
            e.requestOptions.headers["authorization"] = "Bearer $newToken";
            e.requestOptions.headers["Content-Type"] = "application/json";

            // retry the original request with new token
            final cloned = await dio.fetch(e.requestOptions);
            return handler.resolve(cloned);
          } catch (_) {
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

String? _getAccessToken(Ref ref) =>
    ref.read(keycloakServiceProvider).value?.accessToken;

Future<String?> _refreshToken(Ref ref) async {
  await ref.read(keycloakServiceProvider).value?.exchangeTokens();
  return ref.watch(keycloakServiceProvider).value?.accessToken;
}
