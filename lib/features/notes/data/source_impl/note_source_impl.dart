import 'package:disciple/features/notes/data/model/note_model.dart';
import 'package:disciple/features/notes/data/model/single_note_model.dart';
import 'package:disciple/features/notes/domain/entity/note_entity.dart';
import 'package:disciple/features/notes/domain/source/note_source.dart';

class NoteSourceImpl implements NoteSource {
  @override
  Future<NoteModel> addNote({required NoteEntity entity}) {
    // TODO: implement addNote
    throw UnimplementedError();
  }

  @override
  Future<void> deleteNote({required String id}) {
    // TODO: implement deleteNote
    throw UnimplementedError();
  }

  @override
  Future<SingleNoteModel?> getNoteById({required String id}) {
    // TODO: implement getNoteById
    throw UnimplementedError();
  }

  @override
  Future<List<NoteModel>> getNotes() {
    // TODO: implement getNotes
    throw UnimplementedError();
  }

  @override
  Future<SingleNoteModel> updateNote({
    required String id,
    required NoteEntity entity,
  }) {
    // TODO: implement updateNote
    throw UnimplementedError();
  }
}
