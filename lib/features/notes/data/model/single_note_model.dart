import 'package:disciple/features/notes/data/model/note_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'single_note_model.freezed.dart';
part 'single_note_model.g.dart';

@freezed
abstract class SingleNoteModel with _$SingleNoteModel {
  const factory SingleNoteModel({
    @Default(false) bool success,
    NoteModel? note,
  }) = _SingleNoteModel;

  factory SingleNoteModel.fromJson(Map<String, dynamic> json) =>
      _$SingleNoteModelFromJson(json);
}
