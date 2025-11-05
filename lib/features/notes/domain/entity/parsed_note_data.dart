import 'dart:convert';

import 'package:disciple/app/core/database/app_database.dart';
import 'package:disciple/features/notes/data/model/scripture_reference.dart';

/// A wrapper around the raw [NoteData] class to provide clean, parsed fields.
class ParsedNoteData {
  ParsedNoteData(this._noteData);

  final NoteData? _noteData;

  String? get id => _noteData?.id;
  String? get title => _noteData?.title;
  String? get content => _noteData?.content;
  DateTime? get createdAt => _noteData?.createdAt;
  DateTime? get updatedAt => _noteData?.updatedAt;

  List<ScriptureReference> get scriptureReferences {
    if (_noteData?.scriptureReferences.isEmpty ?? true) return [];
    final List<dynamic> jsonList = json.decode(_noteData!.scriptureReferences);
    return jsonList
        .map(
          (item) => ScriptureReference.fromJson(item as Map<String, dynamic>),
        )
        .toList();
  }

  List<String> get images {
    if (_noteData?.images.isEmpty ?? true) return [];
    final List<dynamic> jsonList = json.decode(_noteData!.images);
    return jsonList.map((item) => item as String).toList();
  }
}
