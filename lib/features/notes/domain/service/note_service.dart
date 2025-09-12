import 'package:disciple/app/core/database/app_database.dart';
import 'package:disciple/features/notes/domain/entity/note_entity.dart';
import 'package:disciple/features/notes/domain/entity/parsed_note_data.dart';

abstract class NoteService {
  Future<void> addNote({required NoteEntity entity});
  Stream<List<NoteData>> watchNotes({required NoteEntity entity});
  Future<ParsedNoteData?> getNoteById({required String id});
}
