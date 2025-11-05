import 'package:dio/dio.dart';
import 'package:disciple/app/core/database/app_database.dart';
import 'package:disciple/features/notes/domain/entity/note_entity.dart';
import 'package:disciple/features/notes/domain/entity/parsed_note_data.dart';
import 'package:disciple/features/notes/domain/usecase/watch_notes_usecase.dart';

abstract class NoteService {
  Future<void> addNote({required NoteEntity entity, CancelToken? cancelToken});
  Stream<List<NoteData>> watchNotes({
    WatchNotesParams? parameter,
    CancelToken? cancelToken,
  });
  Future<void> getNotes({
    WatchNotesParams? parameter,
    CancelToken? cancelToken,
  });
  Future<ParsedNoteData?> getNoteById({
    required String id,
    CancelToken? cancelToken,
  });
  Future<bool> deleteNote({required String id, CancelToken? cancelToken});
  Future<bool> updateNote({
    required NoteEntity entity,
    CancelToken? cancelToken,
  });
}
