import 'package:dio/dio.dart';
import 'package:disciple/app/core/database/app_database.dart';
import 'package:disciple/features/notes/domain/entity/note_entity.dart';
import 'package:disciple/features/notes/domain/usecase/watch_notes_usecase.dart';

abstract class NoteRepository {
  Future<int> addNote({required NoteEntity entity, CancelToken? cancelToken});
  Future<bool> updateNote({
    required NoteEntity entity,
    CancelToken? cancelToken,
  });
  Future<bool> deleteNote({required String id, CancelToken? cancelToken});
  Stream<List<NoteData>> watchNotes({
    WatchNotesParams? params,
    CancelToken? cancelToken,
  });
  Future<void> getNotes({WatchNotesParams? params, CancelToken? cancelToken});
  Future<NoteData?> getNoteById({required String id, CancelToken? cancelToken});
}
