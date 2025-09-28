import 'package:dio/dio.dart';
import 'package:disciple/app/config/app_config.dart';
import 'package:disciple/app/core/http/app_http_client.dart';
import 'package:disciple/app/core/http/error_wrapper.dart';
import 'package:disciple/features/authentication/services/keycloak_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

/// ✅ Provides a configured Dio instance
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.apiBaseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
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

  // 🔐 Interceptors
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Inject auth token if available
        final token = _getAccessToken(ref);

        if (token != null) {
          options.headers["authorization"] = "Bearer $token";
        }
        // Only set Content-Type if it's not a multipart request
        if (options.contentType?.contains('multipart/form-data') != true) {
          options.headers["Content-Type"] = "application/json";
        }
        // Add accept header
        options.headers["accept"] = "application/json";

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
        if (apiError.errorType == 401) {
          try {
            final newToken = await _refreshToken(ref);
            e.requestOptions.headers["authorization"] = "Bearer $newToken";
            // Only set Content-Type if it's not a multipart request
            if (e.requestOptions.contentType?.contains('multipart/form-data') !=
                true) {
              e.requestOptions.headers["Content-Type"] = "application/json";
            }
            // Add accept header
            e.requestOptions.headers["accept"] = "application/json";

            // retry the original request with new token
            final cloned = await dio.fetch(e.requestOptions);
            return handler.resolve(cloned);
          } catch (_) {
            // let it fall through (user must re-login)
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
    ref.read(keycloakServiceProvider).value?.accessToken;

Future<String?> _refreshToken(Ref ref) async {
  await ref.read(keycloakServiceProvider).value?.exchangeTokens();
  return ref.watch(keycloakServiceProvider).value?.accessToken;
}

final networkServiceProvider = Provider<AppHttpClient>((ref) {
  final dio = ref.read(dioProvider);
  return AppHttpClient.internal(dio: dio);
});
