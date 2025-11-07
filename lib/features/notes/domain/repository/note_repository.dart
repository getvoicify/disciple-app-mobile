<<<<<<< HEAD
import 'package:disciple/app/core/database/app_database.dart';
import 'package:disciple/features/notes/domain/entity/note_entity.dart';

abstract class NoteRepository {
  Future<int> addNote({required NoteEntity entity});
  Future<bool> updateNote({required NoteEntity entity});
  Future<bool> deleteNote({required String id});
  Stream<List<NoteData>> watchNotes({
    int limit = 20,
    int offset = 0,
    String? query,
  });
  Future<NoteData?> getNoteById({required String id});
=======
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
>>>>>>> b05cc9c14293b73379b299e1f81efe7ebc10826b
}
