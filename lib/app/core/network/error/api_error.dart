import 'package:dio/dio.dart';
import 'package:disciple/app/core/network/error/error_data.dart';

class ApiError implements Exception {
  final String message;
  final int? statusCode;
  final ErrorData? data;

  ApiError({required this.message, this.statusCode, this.data});

  @override
  String toString() => message;

  factory ApiError.fromDio(DioException e) {
    String msg = "Unexpected error occurred";
    final int? code = e.response?.statusCode;
    ErrorData? errorData;

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.connectionError:
        msg = "Connection timeout, please try again.";
      case DioExceptionType.unknown:
      case DioExceptionType.badResponse:
        msg = _fromStatusCode(e.response);
      case DioExceptionType.cancel:
        msg = "Request was cancelled.";
      default:
        msg = e.message ?? msg;
    }

    return ApiError(message: msg, statusCode: code, data: errorData);
  }

  static String _fromStatusCode(Response? response) {
    String message = '';
    ErrorData? errorData;

    switch (response?.statusCode) {
      case 400:
      case 401:
        errorData = ErrorData.fromJson(response?.data);
        message = errorData.error ?? message;
      default:
        message = "Server error: ${response?.statusCode}";
    }
    return message;
  }
}
