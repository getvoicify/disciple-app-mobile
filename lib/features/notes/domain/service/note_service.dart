import 'package:disciple/app/core/database/app_database.dart';
import 'package:disciple/features/notes/domain/entity/note_entity.dart';

abstract class NoteService {
  Future<void> addNote({required NoteEntity entity});
  Stream<List<NoteData>> watchNotes({required NoteEntity entity});
}
