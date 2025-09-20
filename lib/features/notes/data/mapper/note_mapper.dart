import 'package:disciple/app/core/database/app_database.dart';
import 'package:disciple/app/core/database/helpers/drift_helper.dart';
import 'package:disciple/app/core/mapper/mapper.dart';
import 'package:disciple/features/notes/data/model/note_model.dart';
import 'package:disciple/features/notes/domain/interface/i_note.dart';
import 'package:drift/drift.dart';

/// A mapper class that implements the generic [Mapper] interface to convert
/// a [NoteModel] to a [NoteCompanion].
class NoteToCompanionMapper<T extends INote>
    implements Mapper<T, NoteCompanion> {
  @override
  NoteCompanion insert(T input, {bool isSynced = false}) => NoteCompanion(
    id: Value(DriftUtils.generateId(input.id)),
    title: Value(input.title ?? ''),
    content: Value(input.content ?? ''),
    scriptureReferences: Value(
      DriftUtils.encodeScriptureRefs(input.scriptureReferences),
    ),
    images: Value(DriftUtils.encodeList(input.images)),
    createdAt: Value(DriftUtils.timestampOrNow(input.createdAt)),
    updatedAt: Value(DriftUtils.timestampOrNow(input.updatedAt)),
    isSynced: Value(isSynced),
  );

  @override
  NoteCompanion update(T input, {bool isSynced = false}) => NoteCompanion(
    title: Value(input.title ?? ''),
    content: Value(input.content ?? ''),
    scriptureReferences: Value(
      DriftUtils.encodeScriptureRefs(input.scriptureReferences),
    ),
    images: Value(DriftUtils.encodeList(input.images)),
    updatedAt: Value(DriftUtils.timestampOrNow(input.updatedAt)),
    isSynced: Value(isSynced),
  );
}
