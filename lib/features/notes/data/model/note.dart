<<<<<<< HEAD
import 'package:drift/drift.dart';

class Note extends Table {
  /// Primary key – UUID
  TextColumn get id => text()();

  /// Title of the note (limit to 255 chars for optimization)
  TextColumn get title => text().withLength(min: 1, max: 255)();

  /// Main note body
  TextColumn get content => text()();

  /// Scripture references stored as JSON string - using text type
  TextColumn get scriptureReferences => text()();

  /// Image paths/URLs stored as JSON array - using text type
  TextColumn get images => text()();

  /// Creation timestamp
  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now())();

  /// Last update timestamp (nullable until first update)
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
=======
import 'package:disciple/app/core/database/helpers/drift_helper.dart';
import 'package:disciple/features/notes/data/model/scripture_reference.dart';
import 'package:disciple/features/notes/domain/interface/i_note.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'note.freezed.dart';
part 'note.g.dart';

@freezed
abstract class Note with _$Note implements INote {
  const factory Note({
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
  }) = _Note;

  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);
>>>>>>> b05cc9c14293b73379b299e1f81efe7ebc10826b
}
