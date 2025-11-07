import 'package:dio/dio.dart';
import 'package:disciple/app/config/app_logger.dart';
import 'package:disciple/app/utils/extension.dart';
import 'package:disciple/features/devotionals/data/model/devotional.dart';
import 'package:disciple/features/devotionals/domain/repository/devotional_repository.dart';
import 'package:disciple/features/devotionals/domain/service/devotional_service.dart';

class DevotionalServiceImpl implements DevotionalService {
  final _logger = getLogger('DevotionalServiceImpl');

  final DevotionalRepository _repository;

  DevotionalServiceImpl({required DevotionalRepository repository})
    : _repository = repository;

  @override
  Future<List<Devotional>> getDevotionals({
    DateTime? date,
    CancelToken? cancelToken,
  }) async {
    List<Devotional> result = [];
    try {
      final response = await _repository.getDevotionals(
        cancelToken: cancelToken,
      );
      result = response?.data[date?.yyyyMMdd] ?? [];
    } catch (e) {
      _logger.e('An error occurred getting devotionals: $e');
      rethrow;
    }
    return result;
  }
}
