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
}
