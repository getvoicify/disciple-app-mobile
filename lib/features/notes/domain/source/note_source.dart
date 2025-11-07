import 'package:disciple/features/notes/data/model/note.dart';
import 'package:disciple/features/notes/domain/entity/note_entity.dart';
import 'package:disciple/features/notes/domain/usecase/watch_notes_usecase.dart';
import 'package:dio/dio.dart';

abstract class NoteSource {
  Future<Note> addNote({required NoteEntity entity, CancelToken? cancelToken});
  Future<Note> updateNote({
    required NoteEntity entity,
    CancelToken? cancelToken,
  });
  Future<void> deleteNote({required String id, CancelToken? cancelToken});
  Future<List<Note>> getNotes({
    WatchNotesParams? parameter,
    CancelToken? cancelToken,
  });
  Future<Note?> getNoteById({required String id, CancelToken? cancelToken});
}
