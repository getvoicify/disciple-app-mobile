import 'package:disciple/app/core/database/app_database.dart';
import 'package:disciple/app/core/usecase/disciple_usecase.dart';
import 'package:disciple/features/notes/domain/entity/note_entity.dart';
import 'package:disciple/features/notes/domain/service/note_service.dart';

class WatchNotesUseCaseImpl
    implements
        DiscipleStreamUseCaseWithRequiredParam<NoteEntity, List<NoteData>> {
  final NoteService _service;

  WatchNotesUseCaseImpl({required NoteService service}) : _service = service;

  @override
  Stream<List<NoteData>> execute({required NoteEntity parameter}) =>
      _service.watchNotes(entity: parameter);
}
