import 'package:dio/dio.dart';
import 'package:disciple/features/devotionals/data/model/devotional.dart';

abstract class DevotionalRepository {
  Future<DevotionalGroup?> getDevotionals({CancelToken? cancelToken});
}
