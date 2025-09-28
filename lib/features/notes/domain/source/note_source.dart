import 'package:disciple/features/notes/data/model/note.dart';
import 'package:disciple/features/notes/domain/entity/note_entity.dart';
import 'package:disciple/features/notes/domain/usecase/watch_notes_usecase.dart';

abstract class NoteSource {
  Future<Note> addNote({required NoteEntity entity});
  Future<Note> updateNote({required String id, required NoteEntity entity});
  Future<void> deleteNote({required String id});
  Future<List<Note>> getNotes({WatchNotesParams? parameter});
  Future<Note?> getNoteById({required String id});
}
