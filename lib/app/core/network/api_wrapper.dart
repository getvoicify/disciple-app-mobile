import 'package:dio/dio.dart';
import 'package:disciple/app/core/network/error/api_error.dart';

Future<T> execute<T>({required Future<T> Function() run}) async {
  try {
    return await run();
  } on DioException catch (e) {
    throw e.error as ApiError;
  } catch (e) {
    throw ApiError(message: e.toString());
  }
}
