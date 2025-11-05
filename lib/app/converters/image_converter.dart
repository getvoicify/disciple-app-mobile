import 'dart:convert';

import 'package:drift/drift.dart';

class ImagesConverter extends TypeConverter<List<String>, String> {
  const ImagesConverter();

  @override
  List<String> fromSql(String fromDb) {
    if (fromDb.isEmpty) return [];
    final List<dynamic> jsonData = json.decode(fromDb) as List<dynamic>;
    return jsonData.map((e) => e as String).toList();
  }

  @override
  String toSql(List<String> value) => json.encode(value);
}
