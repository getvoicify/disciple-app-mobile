import 'package:disciple/features/notes/data/model/note.dart';
import 'package:disciple/features/notes/domain/entity/note_entity.dart';
import 'package:disciple/features/notes/domain/source/note_source.dart';

class NoteSourceImpl implements NoteSource {
  @override
  Future<Note> addNote({required NoteEntity entity}) {
    throw UnimplementedError();
  }
}
