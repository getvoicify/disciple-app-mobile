import 'package:freezed_annotation/freezed_annotation.dart';

part 'note_state.freezed.dart';

@freezed
abstract class NoteState with _$NoteState {
  const factory NoteState({@Default(false) bool isAddingNote}) = _NoteState;
}
