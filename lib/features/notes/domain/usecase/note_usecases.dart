import 'package:dio/dio.dart';
import 'package:disciple/app/core/usecase/disciple_usecase.dart';
import 'package:disciple/features/notes/domain/entity/note_entity.dart';
import 'package:disciple/features/notes/domain/service/note_service.dart';

class AddNoteUseCaseImpl
    implements DiscipleUseCaseWithRequiredParam<NoteEntity, void> {
  final NoteService _service;

  AddNoteUseCaseImpl({required NoteService service}) : _service = service;

  @override
  Future<void> execute({
    required NoteEntity parameter,
    CancelToken? cancelToken,
<<<<<<< HEAD
  }) async => await _service.addNote(entity: parameter);
=======
  }) async =>
      await _service.addNote(entity: parameter, cancelToken: cancelToken);
>>>>>>> b05cc9c14293b73379b299e1f81efe7ebc10826b
}
