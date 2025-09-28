import 'package:disciple/features/notes/data/model/scripture_reference.dart';
import 'package:disciple/features/notes/domain/interface/i_note.dart';

class NoteEntity implements INote {
  @override
  final String? id;
  @override
  final String? title;
  @override
  final String? content;
  @override
  final List<ScriptureReference> scriptureReferences;
  @override
  final List<String> images;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  NoteEntity({
    this.id,
    this.title,
    this.content,
    this.scriptureReferences = const [],
    this.images = const [],
    this.createdAt,
    this.updatedAt,
  });

  // copyWith for immutability
  NoteEntity copyWith({
    String? id,
    String? title,
    String? content,
    List<ScriptureReference>? scriptureReferences,
    List<String>? images,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => NoteEntity(
    id: id ?? this.id,
    title: title ?? this.title,
    content: content ?? this.content,
    scriptureReferences: scriptureReferences ?? this.scriptureReferences,
    images: images ?? this.images,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};

    if (title != null) {
      json.addAll({'title': title});
    }

    if (content != null) {
      json.addAll({'content': content});
    }

    if (scriptureReferences.isNotEmpty) {
      json.addAll({
        'scriptureReferences': scriptureReferences
            .map((ref) => ref.toJson())
            .toList(),
      });
    }

    if (images.isNotEmpty) {
      json.addAll({'images': images});
    }

    return json;
  }
}
