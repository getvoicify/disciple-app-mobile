import 'package:disciple/features/notes/data/model/note.dart';
import 'package:disciple/features/notes/domain/entity/note_entity.dart';
import 'package:disciple/features/notes/domain/source/note_source.dart';

class NoteSourceImpl implements NoteSource {
  @override
  Future<Note> addNote({required NoteEntity entity}) {
    throw UnimplementedError();
  }

  @override
  Future<bool> deleteNote({required String id}) {
    // TODO: implement deleteNote
    throw UnimplementedError();
  }

  @override
  Future<Note?> getNoteById({required String id}) {
    // TODO: implement getNoteById
    throw UnimplementedError();
  }

  @override
  Future<List<Note>> getNotes() {
    // TODO: implement getNotes
    throw UnimplementedError();
  }

  @override
  Future<Note> updateNote({required String id, required NoteEntity entity}) {
    // TODO: implement updateNote
    throw UnimplementedError();
  }
}
