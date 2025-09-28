import 'package:dio/dio.dart';
import 'package:disciple/app/core/database/app_database.dart';
import 'package:disciple/app/core/usecase/disciple_usecase.dart';
import 'package:disciple/features/notes/domain/service/note_service.dart';

class WatchNotesParams {
  final String? query;
  final String? content;
  final String? startDate;
  final String? endDate;
  final String? book;
  final int? chapter;
  final int? verse;
  final int? limit;
  final int? offset;

  WatchNotesParams({
    this.query,
    this.content,
    this.startDate,
    this.endDate,
    this.book,
    this.chapter,
    this.verse,
    this.limit,
    this.offset,
  });
}

class WatchNotesUseCaseImpl
    implements
        DiscipleStreamUseCaseWithRequiredParam<
          WatchNotesParams,
          List<NoteData>
        > {
  final NoteService _service;

  WatchNotesUseCaseImpl({required NoteService service}) : _service = service;

  @override
  Stream<List<NoteData>> execute({required WatchNotesParams parameter}) =>
      _service.watchNotes(parameter: parameter);
}

class GetNotesUseCaseImpl
    implements DiscipleUseCaseWithRequiredParam<WatchNotesParams, void> {
  final NoteService _service;

  GetNotesUseCaseImpl({required NoteService service}) : _service = service;

  @override
  Future<void> execute({
    required WatchNotesParams parameter,
    CancelToken? cancelToken,
  }) async => await _service.getNotes(parameter: parameter);
}
