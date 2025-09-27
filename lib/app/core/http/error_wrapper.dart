import 'package:dio/dio.dart';
import 'package:disciple/app/common/app_strings.dart';
import 'package:disciple/app/config/app_logger.dart';
import 'package:disciple/app/core/http/error/error.dart';

class ApiError {
  int? errorType = 0;
  final logger = getLogger('ApiError');
  String? errorDescription;

  ApiError({this.errorDescription});

  ApiError.fromDio(Object dioError) {
    _handleError(dioError);
  }

  void _handleError(Object error) {
    if (error is DioException) {
      final DioException dioError = error;
      switch (dioError.type) {
        case DioExceptionType.cancel:
          errorDescription = AppString.requestCancelled;
        case DioExceptionType.unknown:
          errorDescription = AppString.connectionFailed;
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.connectionTimeout:
          errorDescription = AppString.connectionTimeout;
        case DioExceptionType.badResponse:
          errorType = dioError.response?.statusCode;
          errorDescription = handleErrorFromStatusCode(dioError.response);
        case DioExceptionType.badCertificate:
          break;
        case DioExceptionType.connectionError:
          errorDescription = AppString.connectionFailed;
      }
    } else {
      errorDescription = AppString.internalFailure;
    }
  }

  @override
  String toString() => '$errorDescription';

  /// Handles errors based on the HTTP status code of the response.
  ///
  /// This function takes a [Response] object and optionally a [NavigationService]
  /// for testing purposes. It returns a user-friendly error message based on the
  /// status code and performs navigation if the session has timed out.
  ///
  /// - [response]: The HTTP response that contains the status code and error data.
  /// - [navigationServiceTest]: Optional. A navigation service for testing navigation behavior.
  ///
  /// Returns a user-friendly error message as a [String].
  String? handleErrorFromStatusCode(Response? response) {
    // Initialize the error message as an empty string.
    String message = '';

    // Determine the error message based on the status code.
    switch (response?.statusCode) {
      case 401:
        message = AppString.sessionTimeout;
      case 400:
      case 402:
      case 403:
      case 404:
      case 409:
      case 412:
      case 422:
        message = ErrorData.fromJson(response?.data).error ?? '';
      case 500:
      case 405:
      case 429:
        // Handle too many requests error.
        message = ErrorData.fromJson(response?.data).error ?? '';
      case 503:
        // Handle service unavailable error.
        message = AppString.serviceUnavailable;
      default:
        // Default case if the status code does not match any of the above.

        break;
    }

    // Return the error message.
    return message;
  }
}
