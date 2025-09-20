import 'package:disciple/app/core/database/helpers/drift_helper.dart';
import 'package:disciple/features/notes/data/model/scripture_reference.dart';
import 'package:disciple/features/notes/domain/interface/i_note.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'note_model.freezed.dart';
part 'note_model.g.dart';

@freezed
abstract class NoteModel with _$NoteModel implements INote {
  const factory NoteModel({
    String? id,
    String? title,
    String? content,
    String? date,
    @JsonKey(
      name: 'scriptureReferences',
      fromJson: DriftUtils.scriptureReferencesFromJson,
      toJson: DriftUtils.encodeScriptureRefs,
    )
    @Default([])
    List<ScriptureReference> scriptureReferences,
    @Default([]) List<String> images,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _NoteModel;

  factory NoteModel.fromJson(Map<String, dynamic> json) =>
      _$NoteModelFromJson(json);
}
