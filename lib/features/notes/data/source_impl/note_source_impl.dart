import 'package:disciple/app/core/http/api_path.dart';
import 'package:disciple/features/notes/data/model/note.dart';
import 'package:disciple/app/core/http/app_http_client.dart';
import 'package:disciple/features/notes/domain/entity/note_entity.dart';
import 'package:disciple/features/notes/domain/source/note_source.dart';
import 'package:disciple/features/notes/domain/usecase/watch_notes_usecase.dart';
import 'package:uuid/uuid.dart';

class NoteSourceImpl implements NoteSource {
  final AppHttpClient _client;

  NoteSourceImpl({required AppHttpClient client}) : _client = client;

  @override
  Future<Note> addNote({required NoteEntity entity}) async {
    final response = await _client.request(
      path: ApiPath.notes,
      requestType: RequestType.post,
      data: entity.toJson(),
    );

    final result = response.data as Map<String, dynamic>;
    return Note.fromJson(result['note'] as Map<String, dynamic>);
  }

  @override
  Future<void> deleteNote({required String id}) async {
    await _client.request(
      path: '${ApiPath.notes}/$id',
      requestType: RequestType.delete,
    );
    return;
  }

  @override
  Future<Note?> getNoteById({required String id}) async {
    final response = await _client.request(
      path: '${ApiPath.notes}/$id',
      requestType: RequestType.get,
    );

    final result = response.data as Map<String, dynamic>;
    return Note.fromJson(result['note'] as Map<String, dynamic>);
  }

  @override
  Future<Note> updateNote({
    required String id,
    required NoteEntity entity,
  }) async {
    final response = await _client.request(
      path: '${ApiPath.notes}/$id',
      requestType: RequestType.put,
      data: entity.toJson(),
    );

    final result = response.data as Map<String, dynamic>;
    return Note.fromJson(result['note'] as Map<String, dynamic>);
  }

  @override
  Future<List<Note>> getNotes({WatchNotesParams? parameter}) async {
    await Future.delayed(const Duration(seconds: 2));
    return List.generate(
      20,
      (index) => Note(
        id: const Uuid().v4(),
        title: 'Note $index',
        content: 'Content $index',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ).toList();
  }
}
