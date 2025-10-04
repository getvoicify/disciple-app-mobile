import 'package:dio/dio.dart';
import 'package:disciple/app/core/database/app_database.dart';
import 'package:disciple/app/core/usecase/disciple_usecase.dart';
import 'package:disciple/features/bible/domain/service/bible_service.dart';

class GetBibleVersionsUsecaseImpl
    implements DiscipleUseCaseWithOutParam<List<Version>> {
  final BibleService _service;

  GetBibleVersionsUsecaseImpl({required BibleService service})
    : _service = service;

  @override
  List<Version> execute([CancelToken? cancelToken]) => _service.getVersions();
}

class GetDailyScriptureUsecaseImpl
    implements DiscipleUseCaseWithOutParam<Future<BibleVerse?>> {
  final BibleService _service;

  GetDailyScriptureUsecaseImpl({required BibleService service})
    : _service = service;

  @override
  Future<BibleVerse?> execute([CancelToken? cancelToken]) async =>
      await _service.getDailyScripture();
}
