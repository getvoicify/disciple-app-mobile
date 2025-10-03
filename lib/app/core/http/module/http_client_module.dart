import 'package:dio/dio.dart';
import 'package:disciple/app/config/app_config.dart';
import 'package:disciple/app/core/http/app_http_client.dart';
import 'package:disciple/app/core/http/error_wrapper.dart';
import 'package:disciple/app/core/manager/keycloak_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

/// ✅ Provides a configured Dio instance for your API
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.apiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 15),
    ),
  );

  // 📝 Logging (only in debug mode)
  if (kDebugMode) {
    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
      ),
    );
  }

  // 🔐 Interceptors (auth, refresh token, error handling)
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        final token = _getAccessToken(ref);

        if (token != null) {
          options.headers["authorization"] = "Bearer $token";
        }
        if (options.contentType?.contains('multipart/form-data') != true) {
          options.headers["Content-Type"] = "application/json";
        }
        options.headers["accept"] = "application/json";

        return handler.next(options);
      },
      onResponse: (response, handler) => handler.next(response),
      onError: (e, handler) async {
        final apiError = ApiError.fromDio(e);

        if (apiError.errorType == 401) {
          try {
            final newToken = await _refreshToken(ref);
            e.requestOptions.headers["authorization"] = "Bearer $newToken";

            if (e.requestOptions.contentType?.contains('multipart/form-data') !=
                true) {
              e.requestOptions.headers["Content-Type"] = "application/json";
            }
            e.requestOptions.headers["accept"] = "application/json";

            final cloned = await dio.fetch(e.requestOptions);
            return handler.resolve(cloned);
          } catch (_) {
            return handler.reject(
              DioException(
                requestOptions: e.requestOptions,
                message: apiError.errorDescription,
                response: e.response,
                error: apiError,
              ),
            );
          }
        }

        return handler.reject(
          DioException(
            requestOptions: e.requestOptions,
            message: apiError.errorDescription,
            response: e.response,
            error: apiError,
          ),
        );
      },
    ),
  );

  return dio;
});

String? _getAccessToken(Ref ref) =>
    ref.read(keycloakManagerProvider).value?.accessToken;

Future<String?> _refreshToken(Ref ref) async {
  await ref.read(keycloakManagerProvider).value?.exchangeTokens();
  return ref.watch(keycloakManagerProvider).value?.accessToken;
}

/// ✅ Default network service for your backend
final networkServiceProvider = Provider<AppHttpClient>((ref) {
  final dio = ref.read(dioProvider);
  return AppHttpClient(dio: dio);
});

/// ✅ Separate Dio instance for Google Maps APIs
final googleServiceProvider = Provider<AppHttpClient>((ref) {
  final googleDio = Dio(
    BaseOptions(
      baseUrl: 'https://maps.googleapis.com',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 15),
      queryParameters: {
        'key': 'AIzaSyBJsZVVNZfDNLlqLYcDzlU-3u8GaufGWKA', // 🔑 Replace securely
      },
    ),
  );

  if (kDebugMode) {
    googleDio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
      ),
    );
  }

  return AppHttpClient(dio: googleDio);
});
