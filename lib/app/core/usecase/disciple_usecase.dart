import 'package:dio/dio.dart';

/// Base class for use cases that don't require input parameters and return a value synchronously.
abstract class DiscipleUseCaseWithOutParam<T> {
  /// Executes the use case without parameters.
  ///
  /// [cancelToken] Optional token to cancel the operation if needed.
  T execute([CancelToken? cancelToken]);
}

/// Base class for use cases that don't require input parameters and return a Future.
abstract class DiscipleUseCaseFutureWithOutParam<T> {
  /// Executes the use case asynchronously without parameters.
  ///
  /// [cancelToken] Optional token to cancel the operation if needed.
  Future<T> execute([CancelToken? cancelToken]);
}

/// Base class for use cases that accept an optional parameter and return a Future.
abstract class DiscipleUseCaseWithOptionalParam<TInput, TReturn> {
  /// Executes the use case with an optional parameter.
  ///
  /// [parameter] Optional input parameter for the use case.
  /// [cancelToken] Optional token to cancel the operation if needed.
  Future<TReturn> execute({TInput? parameter, CancelToken? cancelToken});
}

/// Base class for use cases that require an input parameter and return a Future.
abstract class DiscipleUseCaseWithRequiredParam<TInput, TReturn> {
  /// Executes the use case with a required parameter.
  ///
  /// [parameter] Required input parameter for the use case.
  /// [cancelToken] Optional token to cancel the operation if needed.
  Future<TReturn> execute({
    required TInput parameter,
    CancelToken? cancelToken,
  });
}

/// Base class for use cases that require an input parameter and return a value synchronously.
abstract class DiscipleUseCaseWithInputParameter<TInput, TReturn> {
  /// Executes the use case with a required parameter synchronously.
  ///
  /// [parameter] Required input parameter for the use case.
  /// [cancelToken] Optional token to cancel the operation if needed.
  TReturn execute({required TInput parameter, CancelToken? cancelToken});
}

/// Base class for use cases that require an input parameter and return a Stream.
abstract class DiscipleStreamUseCaseWithRequiredParam<TInput, TReturn> {
  /// Executes the use case with a required parameter and returns a stream.
  ///
  /// [parameter] Required input parameter for the use case.
  /// [cancelToken] Optional token to cancel the operation if needed.
  Stream<TReturn> execute({required TInput parameter});
}
