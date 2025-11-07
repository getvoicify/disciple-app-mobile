import 'package:dio/dio.dart' show CancelToken;
import 'package:disciple/app/core/usecase/disciple_usecase.dart';
import 'package:disciple/features/notes/domain/service/note_service.dart';

class DeleteNoteUseCaseImpl
    implements DiscipleUseCaseWithRequiredParam<String, bool> {
  final NoteService _service;

  DeleteNoteUseCaseImpl({required NoteService service}) : _service = service;

  @override
  Future<bool> execute({required String parameter, CancelToken? cancelToken}) =>
<<<<<<< HEAD
      _service.deleteNote(id: parameter);
=======
      _service.deleteNote(id: parameter, cancelToken: cancelToken);
>>>>>>> b05cc9c14293b73379b299e1f81efe7ebc10826b
}
