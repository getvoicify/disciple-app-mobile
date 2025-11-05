import 'package:dio/dio.dart';
import 'package:disciple/features/devotionals/data/model/devotional.dart';

abstract class DevotionalSource {
  Future<DevotionalGroup?> getDevotionals({CancelToken? cancelToken});
}
