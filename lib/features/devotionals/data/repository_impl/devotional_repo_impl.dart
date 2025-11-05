import 'package:dio/dio.dart';
import 'package:disciple/features/devotionals/data/model/devotional.dart';
import 'package:disciple/features/devotionals/domain/repository/devotional_repository.dart';
import 'package:disciple/features/devotionals/domain/source/devotional_source.dart';

class DevotionalRepoImpl implements DevotionalRepository {
  final DevotionalSource _source;

  DevotionalRepoImpl({required DevotionalSource source}) : _source = source;

  @override
  Future<DevotionalGroup?> getDevotionals({CancelToken? cancelToken}) =>
      _source.getDevotionals(cancelToken: cancelToken);
}
