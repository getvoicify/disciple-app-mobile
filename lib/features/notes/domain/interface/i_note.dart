import 'package:disciple/features/notes/data/model/scripture_reference.dart';

/// An interface that defines the common properties between
/// NoteModel and NoteEntity.
abstract class INote {
  String? get id;
  String? get title;
  String? get content;
  List<ScriptureReference> get scriptureReferences;
  List<String> get images;
  DateTime? get createdAt;
  DateTime? get updatedAt;
}
