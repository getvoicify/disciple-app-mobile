import 'package:dio/dio.dart';
import 'package:disciple/app/core/database/app_database.dart';
import 'package:disciple/app/core/usecase/disciple_usecase.dart';
import 'package:disciple/features/bible/domain/param/bible_search_params.dart';
import 'package:disciple/features/bible/domain/service/bible_service.dart';

class SearchBibleUsecaseImpl
    implements
        DiscipleUseCaseWithRequiredParam<BibleSearchParams, List<BibleVerse>> {
  final BibleService _service;

  SearchBibleUsecaseImpl({required BibleService service}) : _service = service;

  @override
  Future<List<BibleVerse>> execute({
    required BibleSearchParams parameter,
    CancelToken? cancelToken,
  }) async => await _service.searchBibles(parameter);
}
