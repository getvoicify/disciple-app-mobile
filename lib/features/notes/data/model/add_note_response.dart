import 'package:disciple/features/notes/data/model/note_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_note_response.freezed.dart';
part 'add_note_response.g.dart';

@freezed
abstract class AddNoteResponse with _$AddNoteResponse {
  const factory AddNoteResponse({
    required NoteModel note,
    required bool success,
  }) = _AddNoteResponse;
  factory AddNoteResponse.fromJson(Map<String, dynamic> json) =>
      _$AddNoteResponseFromJson(json);
}
