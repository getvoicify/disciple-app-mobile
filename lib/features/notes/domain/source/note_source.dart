import 'package:disciple/features/notes/data/model/note_model.dart';
import 'package:disciple/features/notes/data/model/single_note_model.dart';
import 'package:disciple/features/notes/domain/entity/note_entity.dart';

abstract class NoteSource {
  Future<NoteModel> addNote({required NoteEntity entity});
  Future<SingleNoteModel> updateNote({
    required String id,
    required NoteEntity entity,
  });
  Future<void> deleteNote({required String id});
  Future<List<NoteModel>> getNotes();
  Future<SingleNoteModel?> getNoteById({required String id});
}
