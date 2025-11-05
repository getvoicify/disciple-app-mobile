import 'package:dio/dio.dart';
import 'package:disciple/features/devotionals/data/model/devotional.dart';

abstract class DevotionalService {
  Future<List<Devotional>> getDevotionals({
    DateTime? date,
    CancelToken? cancelToken,
  });
}
