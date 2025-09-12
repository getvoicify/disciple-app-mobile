import 'package:disciple/app/core/database/app_database.dart';
import 'package:disciple/features/notes/domain/entity/note_entity.dart';

abstract class NoteRepository {
  Future<int> addNote({required NoteEntity entity});
  Future<NoteData?> updateNote({
    required String id,
    required NoteEntity entity,
  });
  Future<bool> deleteNote({required String id});
  Stream<List<NoteData>> watchNotes({int limit = 20, int offset = 0});
  Future<NoteData?> getNoteById({required String id});
}
