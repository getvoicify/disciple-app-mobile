<<<<<<< HEAD
=======
import 'package:dio/dio.dart';
>>>>>>> b05cc9c14293b73379b299e1f81efe7ebc10826b
import 'package:disciple/app/core/database/app_database.dart';
import 'package:disciple/app/core/usecase/disciple_usecase.dart';
import 'package:disciple/features/notes/domain/service/note_service.dart';

class WatchNotesParams {
  final String? query;
<<<<<<< HEAD
  final int? limit;
  final int? offset;

  WatchNotesParams({this.query, this.limit, this.offset});
=======
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
>>>>>>> b05cc9c14293b73379b299e1f81efe7ebc10826b
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
<<<<<<< HEAD
  Stream<List<NoteData>> execute({required WatchNotesParams parameter}) =>
      _service.watchNotes(parameter: parameter);
=======
  Stream<List<NoteData>> execute({
    required WatchNotesParams parameter,
    CancelToken? cancelToken,
  }) => _service.watchNotes(parameter: parameter, cancelToken: cancelToken);
}

class GetNotesUseCaseImpl
    implements DiscipleUseCaseWithRequiredParam<WatchNotesParams, void> {
  final NoteService _service;

  GetNotesUseCaseImpl({required NoteService service}) : _service = service;

  @override
  Future<void> execute({
    required WatchNotesParams parameter,
    CancelToken? cancelToken,
  }) async =>
      await _service.getNotes(parameter: parameter, cancelToken: cancelToken);
>>>>>>> b05cc9c14293b73379b299e1f81efe7ebc10826b
}
