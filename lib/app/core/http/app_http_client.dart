import 'dart:async';

import 'package:dio/dio.dart';
import 'package:disciple/app/config/app_logger.dart';
import 'package:disciple/app/core/http/error_wrapper.dart';

enum RequestType { post, get, put, delete, upload, patch }

class AppHttpClient {
  static const int connectTimeout = 500000;
  static const int receiveTimeout = 500000;

  Dio? dio;
  final logger = getLogger('HttpClient');

  AppHttpClient() {
    _initializeDio();
  }

  AppHttpClient.internal({required this.dio});

  void _initializeDio() {
    if (dio != null) {
      dio!.transformer = BackgroundTransformer();
    }
  }

  Future<Response> request({
    required String path,
    required RequestType requestType,
    Map<String, dynamic>? queryParams,
    data,
    FormData? formData,
    ResponseType responseType = ResponseType.json,
    Options? options,
    classTag = '',
    void Function(int, int)? onSendProgress,
    CancelToken? cancelToken,
  }) async {
    Response response;
    final params = queryParams ?? {};
    if (params.keys.contains("searchTerm")) {
      params["searchTerm"] = Uri.encodeQueryComponent(params["searchTerm"]);
    }

    try {
      final requestOptions = options ?? await _getOption();

      switch (requestType) {
        case RequestType.post:
          response = await dio!.post(
            path,
            queryParameters: params,
            data: data,
            cancelToken: cancelToken,
            options: requestOptions,
            onSendProgress: onSendProgress,
          );

        case RequestType.get:
          response = await dio!.get(
            path,
            queryParameters: params,
            cancelToken: cancelToken,
            options: requestOptions,
          );

        case RequestType.put:
          response = await dio!.put(
            path,
            queryParameters: params,
            data: data,
            cancelToken: cancelToken,
            options: requestOptions,
            onSendProgress: onSendProgress,
          );

        case RequestType.patch:
          response = await dio!.patch(
            path,
            queryParameters: params,
            data: data,
            cancelToken: cancelToken,
            options: requestOptions,
            onSendProgress: onSendProgress,
          );

        case RequestType.delete:
          response = await dio!.delete(
            path,
            queryParameters: params,
            data: data,
            cancelToken: cancelToken,
            options: requestOptions,
          );

        case RequestType.upload:
          response = await dio!.post(
            path,
            data: formData,
            queryParameters: params,
            cancelToken: cancelToken,
            options: requestOptions,
            onSendProgress: onSendProgress,
          );
      }

      return response;
    } catch (error, stackTrace) {
      final apiError = ApiError.fromDio(error);
      return Future.error(apiError, stackTrace);
    }
  }

  Future<Options> _getOption({bool upload = false}) async => Options(
    followRedirects: false,
    receiveTimeout: const Duration(minutes: AppHttpClient.receiveTimeout),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Accept': 'application/json',
      "source": "mobile",
      if (upload) "Content-Disposition": "form-data",
      if (upload) "Content-Type": "multipart/form-data",
      if (upload) "x-amz-acl": "public-read",
    },
  );
}
