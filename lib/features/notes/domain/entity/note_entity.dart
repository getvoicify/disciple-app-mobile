import 'dart:convert';
import 'package:disciple/app/core/database/app_database.dart';
import 'package:disciple/features/notes/data/model/scripture_reference.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

class NoteEntity {
  final String? id;
  final String? title;
  final String? content;
  final List<ScriptureReference> scriptureReferences;
  final List<String> images;
  final DateTime? createdAt;
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

  /// 🔑 Convert to Drift Companion
  NoteCompanion toCompanion() {
    final now = DateTime.now();
    // Always generate a new UUID if not provided
    final noteId = id ?? const Uuid().v4();

    return NoteCompanion(
      id: Value(noteId),
      title: Value(title ?? ''),
      content: Value(content ?? ''),
      scriptureReferences: Value(_encodeScriptureReferences()),
      images: Value(_encodeImages()),
      createdAt: Value(createdAt ?? now),
      updatedAt: Value(updatedAt ?? now),
    );
  }

  /// For updating existing notes (⚠️ no id, no createdAt)
  NoteCompanion toUpdateCompanion() => NoteCompanion(
    title: title != null ? Value(title!) : const Value.absent(),
    content: content != null ? Value(content!) : const Value.absent(),
    scriptureReferences: Value(_encodeScriptureReferences()),
    images: Value(_encodeImages()),
    updatedAt: Value(DateTime.now()),
  );

  // Helper method to encode scriptureReferences to JSON string
  String _encodeScriptureReferences() {
    final List<Map<String, dynamic>> jsonList = scriptureReferences
        .map((ref) => ref.toJson())
        .toList();
    return json.encode(jsonList);
  }

  // Helper method to encode images to JSON string
  String _encodeImages() => json.encode(images);

  Map<String, dynamic> toJson() => {
    'title': title,
    'content': content,
    'scriptureReferences': scriptureReferences
        .map((ref) => ref.toJson())
        .toList(),
    'images': images,
  };
}
