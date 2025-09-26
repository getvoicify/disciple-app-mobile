import 'package:dio/dio.dart';
import 'package:disciple/app/core/usecase/disciple_usecase.dart';
import 'package:disciple/features/bible/domain/service/bible_service.dart';

class SearchBibleBooksUsecaseImpl
    implements DiscipleUseCaseWithRequiredParam<String, List<String>> {
  final BibleService _service;

  SearchBibleBooksUsecaseImpl({required BibleService service})
    : _service = service;

  @override
  Future<List<String>> execute({
    required String parameter,
    CancelToken? cancelToken,
  }) async => await _service.getBooks(parameter);
}
