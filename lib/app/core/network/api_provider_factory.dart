import 'package:dio/dio.dart';
import 'package:disciple/app/core/network/module/network_module.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A factory to create a Riverpod provider for an API class that depends on Dio.
Provider<T> createApiProvider<T>(T Function(Dio dio) create) =>
    Provider<T>((ref) {
      final dio = ref.read(dioProvider);
      return create(dio);
    });
