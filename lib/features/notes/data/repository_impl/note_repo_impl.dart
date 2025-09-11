import 'package:disciple/features/notes/data/model/note.dart';
import 'package:disciple/features/notes/domain/entity/note_entity.dart';
import 'package:disciple/features/notes/domain/repository/note_repository.dart';
import 'package:disciple/features/notes/domain/source/note_source.dart';

class NoteRepoImpl implements NoteRepository {
  final NoteSource _source;

  NoteRepoImpl({required NoteSource source}) : _source = source;

  @override
  Future<Note> addNote({required NoteEntity entity}) async =>
      await _source.addNote(entity: entity);
}
