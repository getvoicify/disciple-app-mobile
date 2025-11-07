import 'package:disciple/features/notes/domain/entity/parsed_note_data.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'note_state.freezed.dart';
part 'note_state.g.dart';

@freezed
abstract class NoteState with _$NoteState {
  const factory NoteState({
    @Default(false) bool isAddingNote,
    @Default(false) bool isLoadingNote,
    @Default(false) bool isDeletingNote,
    @Default(false) bool isUpdatingNote,
<<<<<<< HEAD
=======
    @Default(false) bool isLoadingNotes,
>>>>>>> b05cc9c14293b73379b299e1f81efe7ebc10826b
    @JsonKey(includeFromJson: false, includeToJson: false) ParsedNoteData? note,
  }) = _NoteState;
}
