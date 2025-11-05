import 'package:dio/dio.dart';
import 'package:disciple/app/core/usecase/disciple_usecase.dart';
import 'package:disciple/features/bible/data/model/chapter_model.dart';
import 'package:disciple/features/bible/domain/param/bible_search_params.dart';
import 'package:disciple/features/bible/domain/service/bible_service.dart';

class SearchBibleChaptersUsecaseImpl
    implements
        DiscipleUseCaseWithRequiredParam<BibleSearchParams, List<ChapterInfo>> {
  final BibleService _service;

  SearchBibleChaptersUsecaseImpl({required BibleService service})
    : _service = service;

  @override
  Future<List<ChapterInfo>> execute({
    required BibleSearchParams parameter,
    CancelToken? cancelToken,
  }) async => await _service.getBookInfo(parameter);
}
