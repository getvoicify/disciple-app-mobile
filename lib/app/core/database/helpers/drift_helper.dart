import 'dart:convert';
import 'package:disciple/features/notes/data/model/scripture_reference.dart';
import 'package:uuid/uuid.dart';

class DriftUtils {
  static String generateId([String? id]) => id ?? const Uuid().v4();

  static String encodeList(List<dynamic> list) => json.encode(list);

  static String encodeScriptureRefs(List<ScriptureReference> refs) =>
      json.encode(refs.map((e) => e.toJson()).toList());

  static DateTime timestampOrNow(DateTime? value) => value ?? DateTime.now();

  static List<ScriptureReference> scriptureReferencesFromJson(
    List<dynamic> json,
  ) => json.map((e) => ScriptureReference.fromJson(e)).toList();
}
