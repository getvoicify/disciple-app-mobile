<<<<<<< HEAD
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
=======
import 'package:dio/dio.dart';
import 'package:disciple/app/core/http/api_path.dart';
import 'package:disciple/app/core/http/app_http_client.dart';
import 'package:disciple/features/notes/data/model/note.dart';
import 'package:disciple/features/notes/domain/entity/note_entity.dart';
import 'package:disciple/features/notes/domain/source/note_source.dart';
import 'package:disciple/features/notes/domain/usecase/watch_notes_usecase.dart';

class NoteSourceImpl implements NoteSource {
  final AppHttpClient _client;

  NoteSourceImpl({required AppHttpClient client}) : _client = client;

  @override
  Future<Note> addNote({
    required NoteEntity entity,
    CancelToken? cancelToken,
  }) async {
    final response = await _client.request(
      path: ApiPath.notes,
      requestType: RequestType.post,
      data: entity.toJson(),
      cancelToken: cancelToken,
    );

    final result = response.data as Map<String, dynamic>;
    return Note.fromJson(result['note'] as Map<String, dynamic>);
  }

  @override
  Future<void> deleteNote({
    required String id,
    CancelToken? cancelToken,
  }) async {
    await _client.request(
      path: '${ApiPath.notes}/$id',
      requestType: RequestType.delete,
      cancelToken: cancelToken,
    );
    return;
  }

  @override
  Future<Note?> getNoteById({
    required String id,
    CancelToken? cancelToken,
  }) async {
    final response = await _client.request(
      path: '${ApiPath.notes}/$id',
      requestType: RequestType.get,
      cancelToken: cancelToken,
    );

    final result = response.data as Map<String, dynamic>;
    return Note.fromJson(result['note'] as Map<String, dynamic>);
  }

  @override
  Future<Note> updateNote({
    required NoteEntity entity,
    CancelToken? cancelToken,
  }) async {
    final response = await _client.request(
      path: '${ApiPath.notes}/${entity.id}',
      requestType: RequestType.put,
      data: entity.toJson(),
      cancelToken: cancelToken,
    );

    final result = response.data as Map<String, dynamic>;
    return Note.fromJson(result['note'] as Map<String, dynamic>);
  }

  @override
  Future<List<Note>> getNotes({
    WatchNotesParams? parameter,
    CancelToken? cancelToken,
  }) async {
    final response = await _client.request(
      path: ApiPath.notes,
      requestType: RequestType.get,
      cancelToken: cancelToken,
    );

    final result = response.data as Map<String, dynamic>;
    return (result['notes'] as List<dynamic>)
        .map((e) => Note.fromJson(e as Map<String, dynamic>))
        .toList();
  }
>>>>>>> b05cc9c14293b73379b299e1f81efe7ebc10826b
}
