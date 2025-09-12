import 'package:disciple/app/core/database/app_database.dart';
import 'package:disciple/app/core/usecase/disciple_usecase.dart';
import 'package:disciple/features/notes/domain/service/note_service.dart';

class WatchNotesParams {
  final String? query;
  final int? limit;
  final int? offset;

  WatchNotesParams({this.query, this.limit, this.offset});
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
