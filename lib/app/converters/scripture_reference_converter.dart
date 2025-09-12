import 'package:disciple/features/notes/data/model/scripture_reference.dart';
import 'dart:convert';
import 'package:drift/drift.dart';

class ScriptureReferencesConverter
    extends TypeConverter<List<ScriptureReference>, String> {
  const ScriptureReferencesConverter();

  @override
  List<ScriptureReference> fromSql(String fromDb) {
    if (fromDb.isEmpty) return [];
    final List<dynamic> jsonData = json.decode(fromDb) as List<dynamic>;
    return jsonData
        .map(
          (item) => ScriptureReference.fromJson(item as Map<String, dynamic>),
        )
        .toList();
  }

  @override
  String toSql(List<ScriptureReference> value) =>
      json.encode(value.map((e) => e.toJson()).toList());
}
