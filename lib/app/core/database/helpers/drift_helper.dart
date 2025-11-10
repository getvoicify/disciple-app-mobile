import 'dart:convert';
import 'package:disciple/features/notes/data/model/scripture_reference.dart';
import 'package:uuid/uuid.dart';

import 'dart:math';

final _rand = Random();

class DriftUtils {
  static String generateId([String? id]) => id ?? const Uuid().v4();

  static int generateUniqueId([int? id]) {
    // If an ID was provided, make sure it fits into 32-bit range
    if (id != null) return id & 0x7FFFFFFF;

    // Generate a time-based + random value and trim it to 32-bit
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final randomPart = _rand.nextInt(999);
    final combined = timestamp + randomPart;

    // Fit safely within signed 32-bit integer range (0 → 2,147,483,647)
    return combined & 0x7FFFFFFF;
  }

  static String encodeList(List<dynamic> list) => json.encode(list);

  static String encodeScriptureRefs(List<ScriptureReference> refs) =>
      json.encode(refs.map((e) => e.toJson()).toList());

  static DateTime timestampOrNow(DateTime? value) => value ?? DateTime.now();

  static List<ScriptureReference> scriptureReferencesFromJson(
    List<dynamic> json,
  ) => json.map((e) => ScriptureReference.fromJson(e)).toList();
}
