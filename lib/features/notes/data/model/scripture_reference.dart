import 'package:freezed_annotation/freezed_annotation.dart';

part 'scripture_reference.freezed.dart';
part 'scripture_reference.g.dart';

@freezed
abstract class ScriptureReference with _$ScriptureReference {
  const factory ScriptureReference({
    @Default('') String? book,
    @Default(1) int? chapter,
    @Default(1) int? verse,
    @Default(1) int? endVerse,
  }) = _ScriptureReference;

  factory ScriptureReference.fromJson(Map<String, dynamic> json) =>
      _$ScriptureReferenceFromJson(json);
}
