import 'package:disciple/app/core/network/api_wrapper.dart';
import 'package:disciple/features/notes/data/api/note_api.dart';
import 'package:disciple/features/notes/data/model/note_model.dart';
import 'package:disciple/features/notes/data/model/single_note_model.dart';
import 'package:disciple/features/notes/domain/entity/note_entity.dart';
import 'package:disciple/features/notes/domain/source/note_source.dart';

class NoteSourceImpl implements NoteSource {
  final NoteApi _api;

  NoteSourceImpl({required NoteApi api}) : _api = api;

  @override
  Future<NoteModel> addNote({required NoteEntity entity}) async =>
      await execute(run: () async => await _api.addNote(note: entity));

  @override
  Future<void> deleteNote({required String id}) async =>
      await execute(run: () async => await _api.deleteNote(id));

  @override
  Future<SingleNoteModel?> getNoteById({required String id}) async =>
      await execute(run: () async => await _api.getNoteById(id));

  @override
  Future<List<NoteModel>> getNotes() async =>
      await execute(run: () async => await _api.getNotes());

  @override
  Future<SingleNoteModel> updateNote({
    required String id,
    required NoteEntity entity,
  }) async => await _api.updateNote(id, entity);
}
