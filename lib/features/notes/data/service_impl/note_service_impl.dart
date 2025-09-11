import 'package:disciple/features/notes/data/model/note.dart';
import 'package:disciple/features/notes/domain/entity/note_entity.dart';
import 'package:disciple/features/notes/domain/repository/note_repository.dart';
import 'package:disciple/features/notes/domain/service/note_service.dart';

class NoteServiceImpl implements NoteService {
  final NoteRepository _repository;

  NoteServiceImpl({required NoteRepository repository})
    : _repository = repository;

  @override
  Future<Note> addNote({required NoteEntity entity}) async {
    try {
      return await _repository.addNote(entity: entity);
    } catch (e) {
      rethrow;
    }
  }
}
