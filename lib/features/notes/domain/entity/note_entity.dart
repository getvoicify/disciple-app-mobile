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

  final int? limit;
  final int? offset;

  NoteEntity({
    this.id,
    this.title,
    this.content,
    this.scriptureReferences = const [],
    this.images = const [],
    this.createdAt,
    this.updatedAt,
    this.limit,
    this.offset,
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

  // Helper method to encode scriptureReferences to JSON string
  String _encodeScriptureReferences() {
    final List<Map<String, dynamic>> jsonList = scriptureReferences
        .map((ref) => ref.toJson())
        .toList();
    return json.encode(jsonList);
  }

  // Helper method to encode images to JSON string
  String _encodeImages() => json.encode(images);

  // Helper method to decode scriptureReferences from JSON string
  static List<ScriptureReference> _decodeScriptureReferences(
    String jsonString,
  ) {
    if (jsonString.isEmpty) return [];
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList
        .map(
          (item) => ScriptureReference.fromJson(item as Map<String, dynamic>),
        )
        .toList();
  }

  // Helper method to decode images from JSON string
  static List<String> _decodeImages(String jsonString) {
    if (jsonString.isEmpty) return [];
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((item) => item as String).toList();
  }

  // Create NoteEntity from NoteData
  static NoteEntity fromNoteData(NoteData data) => NoteEntity(
    id: data.id,
    title: data.title,
    content: data.content,
    scriptureReferences: _decodeScriptureReferences(data.scriptureReferences),
    images: _decodeImages(data.images),
    createdAt: data.createdAt,
    updatedAt: data.updatedAt,
  );
}
