import 'package:disciple/features/notes/data/model/note.dart';
import 'package:disciple/features/notes/domain/entity/note_entity.dart';

abstract class NoteSource {
  Future<Note> addNote({required NoteEntity entity});
}
