import 'package:dio/dio.dart';
import 'package:disciple/app/core/usecase/disciple_usecase.dart';
import 'package:disciple/features/notes/domain/entity/parsed_note_data.dart';
import 'package:disciple/features/notes/domain/service/note_service.dart';

class GetNoteByIdUseCaseImpl
    implements DiscipleUseCaseWithRequiredParam<String, ParsedNoteData?> {
  final NoteService _service;

  GetNoteByIdUseCaseImpl({required NoteService service}) : _service = service;

  @override
  Future<ParsedNoteData?> execute({
    required String parameter,
    CancelToken? cancelToken,
<<<<<<< HEAD
  }) async => await _service.getNoteById(id: parameter);
=======
  }) async =>
      await _service.getNoteById(id: parameter, cancelToken: cancelToken);
>>>>>>> b05cc9c14293b73379b299e1f81efe7ebc10826b
}
