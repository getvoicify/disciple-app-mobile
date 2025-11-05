import 'package:dio/dio.dart';
import 'package:disciple/app/core/usecase/disciple_usecase.dart';
import 'package:disciple/features/devotionals/data/model/devotional.dart';
import 'package:disciple/features/devotionals/domain/service/devotional_service.dart';

class GetDevotionalsUseCaseImpl
    implements DiscipleUseCaseWithOptionalParam<DateTime, List<Devotional>> {
  final DevotionalService _service;

  GetDevotionalsUseCaseImpl({required DevotionalService service})
    : _service = service;

  @override
  Future<List<Devotional>> execute({
    DateTime? parameter,
    CancelToken? cancelToken,
  }) async =>
      await _service.getDevotionals(date: parameter, cancelToken: cancelToken);
}
