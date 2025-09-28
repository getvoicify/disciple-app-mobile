import 'package:disciple/app/core/database/app_database.dart';
import 'package:disciple/features/notes/domain/entity/note_entity.dart';
import 'package:disciple/features/notes/domain/usecase/watch_notes_usecase.dart';

abstract class NoteRepository {
  Future<int> addNote({required NoteEntity entity});
  Future<bool> updateNote({required NoteEntity entity});
  Future<bool> deleteNote({required String id});
  Stream<List<NoteData>> watchNotes({WatchNotesParams? params});
  Future<void> getNotes({WatchNotesParams? params});
  Future<NoteData?> getNoteById({required String id});
}
