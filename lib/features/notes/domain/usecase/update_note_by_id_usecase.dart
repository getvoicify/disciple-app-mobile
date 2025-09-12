import 'package:dio/dio.dart';
import 'package:disciple/app/core/usecase/disciple_usecase.dart';
import 'package:disciple/features/notes/domain/entity/note_entity.dart';
import 'package:disciple/features/notes/domain/service/note_service.dart';

class UpdateNoteByIdUseCaseImpl
    implements DiscipleUseCaseWithRequiredParam<NoteEntity, bool> {
  final NoteService _service;

  UpdateNoteByIdUseCaseImpl({required NoteService service})
    : _service = service;

  @override
  Future<bool> execute({
    required NoteEntity parameter,
    CancelToken? cancelToken,
  }) async => await _service.updateNote(entity: parameter);
}
