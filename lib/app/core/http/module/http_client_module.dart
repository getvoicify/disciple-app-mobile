import 'package:dio/dio.dart';
import 'package:disciple/app/config/app_config.dart';
import 'package:disciple/app/core/http/app_http_client.dart';
import 'package:disciple/app/core/http/error_wrapper.dart';
import 'package:disciple/app/core/manager/keycloak_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:disciple/app/core/http/request_queue.dart';

/// Provides a configured Dio instance for your API
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

      // Update the onError interceptor in http_client_module.dart
      onError: (e, handler) async {
        final apiError = ApiError.fromDio(e);
        final requestQueue = ref.read(requestQueueProvider);

        // Skip if this is a retry of a failed request
        if (e.requestOptions.extra['_retry'] == true) {
          return handler.reject(e);
        }

        if (apiError.errorType == 401) {
          try {
            // Skip refresh if we already tried to refresh and failed
            if (e.requestOptions.extra['_refreshed'] == true) {
              throw Exception('Already attempted token refresh');
            }

            // Mark that we're attempting a refresh
            e.requestOptions.extra['_refreshed'] = true;

            final newToken = await _refreshToken(ref);
            if (newToken == null) {
              throw Exception('No token available');
            }

            e.requestOptions.headers["authorization"] = "Bearer $newToken";
            e.requestOptions.extra['_retry'] = true;

            // Update content type headers
            if (e.requestOptions.contentType?.contains('multipart/form-data') !=
                true) {
              e.requestOptions.headers["Content-Type"] = "application/json";
            }
            e.requestOptions.headers["accept"] = "application/json";

            // Retry the request with new token
            final cloned = await dio.fetch(e.requestOptions);
            return handler.resolve(cloned);
          } catch (refreshError) {
            // If refresh fails, save the request and redirect to login
            if (!e.requestOptions.extra.containsKey('_addedToQueue')) {
              requestQueue.add(e.requestOptions);
              e.requestOptions.extra['_addedToQueue'] = true;
            }

            // Only trigger login flow if we're not already in the process of logging in
            if (!e.requestOptions.extra.containsKey('_loginTriggered')) {
              e.requestOptions.extra['_loginTriggered'] = true;

              // Trigger login flow
              final keycloakManager = ref.read(keycloakManagerProvider);
              await keycloakManager.value?.requireLogin();
            }

            return handler.reject(
              DioException(
                requestOptions: e.requestOptions,
                message: 'Authentication required. Please login again.',
                response: e.response,
                error: apiError,
              ),
            );
          }
        }

        return handler.reject(e);
      },
    ),
  );

  return dio;
});

String? _getAccessToken(Ref ref) =>
    ref.read(keycloakManagerProvider).value?.accessToken;

Future<String?> _refreshToken(Ref ref) async {
  try {
    final keycloakManager = ref.read(keycloakManagerProvider).value;
    if (keycloakManager == null || keycloakManager.refreshToken == null) {
      return null; // No refresh token available
    }

    await keycloakManager.exchangeTokens();
    return keycloakManager.accessToken;
  } catch (e) {
    debugPrint('Token refresh failed: $e');
    return null;
  }
}

/// Default network service for your backend
final networkServiceProvider = Provider<AppHttpClient>((ref) {
  final dio = ref.read(dioProvider);
  return AppHttpClient(dio: dio);
});

/// Separate Dio instance for Google Maps APIs
final googleServiceProvider = Provider<AppHttpClient>((ref) {
  final googleDio = Dio(
    BaseOptions(
      baseUrl: 'https://maps.googleapis.com',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 15),
      queryParameters: {
        'key': AppConfig.googleApiKey, // 🔑 Replace securely
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
