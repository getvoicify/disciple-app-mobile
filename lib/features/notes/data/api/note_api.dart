import 'package:dio/dio.dart';
import 'package:disciple/features/notes/data/model/add_note_response.dart';
import 'package:disciple/features/notes/data/model/note_model.dart';
import 'package:disciple/features/notes/data/model/single_note_model.dart';
import 'package:disciple/features/notes/domain/entity/note_entity.dart';
import 'package:retrofit/retrofit.dart';

part 'note_api.g.dart';

@RestApi(baseUrl: 'https://staging.infra.api.pottersville.church')
abstract class NoteApi {
  factory NoteApi(Dio dio, {String baseUrl}) = _NoteApi;

  @GET("/api/notes")
  Future<List<NoteModel>> getNotes();

  @POST("/api/notes")
  Future<AddNoteResponse> addNote({@Body() required NoteEntity note});

  @GET('/api/notes/{noteId}')
  Future<SingleNoteModel> getNoteById(@Path('noteId') String noteId);

  @PUT('/api/notes/{noteId}')
  Future<SingleNoteModel> updateNote(
    @Path() String noteId,
    @Body() NoteEntity note,
  );

  @DELETE('/api/notes/{noteId}')
  Future<void> deleteNote(@Path() String noteId);
}
