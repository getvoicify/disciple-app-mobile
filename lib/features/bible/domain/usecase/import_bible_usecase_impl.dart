import 'package:dio/dio.dart';
import 'package:disciple/app/core/usecase/disciple_usecase.dart';
import 'package:disciple/features/bible/domain/service/bible_service.dart';

class ImportBibleUsecaseImpl
    implements DiscipleUseCaseWithOutParam<Future<void>> {
  final BibleService _service;

  ImportBibleUsecaseImpl({required BibleService service}) : _service = service;

  @override
  Future<void> execute([CancelToken? cancelToken]) async =>
      await _service.importBibles();
}
