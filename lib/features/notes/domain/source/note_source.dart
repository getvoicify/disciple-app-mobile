<<<<<<< HEAD
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
=======
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
>>>>>>> b05cc9c14293b73379b299e1f81efe7ebc10826b
}
