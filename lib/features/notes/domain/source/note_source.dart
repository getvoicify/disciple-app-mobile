import 'package:disciple/features/notes/data/model/note.dart';
import 'package:disciple/features/notes/domain/entity/note_entity.dart';

abstract class NoteSource {
  Future<Note> addNote({required NoteEntity entity});
  Future<Note> updateNote({required String id, required NoteEntity entity});
  Future<bool> deleteNote({required String id});
  Future<List<Note>> getNotes();
  Future<Note?> getNoteById({required String id});
}
