import 'package:dio/dio.dart';
import 'package:disciple/app/core/usecase/disciple_usecase.dart';
import 'package:disciple/features/notes/data/model/note.dart';
import 'package:disciple/features/notes/domain/entity/note_entity.dart';
import 'package:disciple/features/notes/domain/service/note_service.dart';

class AddNoteUseCaseImpl
    implements DiscipleUseCaseWithRequiredParam<NoteEntity, Note> {
  final NoteService _service;

  AddNoteUseCaseImpl({required NoteService service}) : _service = service;

  @override
  Future<Note> execute({
    required NoteEntity parameter,
    CancelToken? cancelToken,
  }) async => await _service.addNote(entity: parameter);
}
