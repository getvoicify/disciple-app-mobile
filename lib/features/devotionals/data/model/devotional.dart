import 'package:disciple/app/core/database/helpers/drift_helper.dart';
import 'package:disciple/features/notes/data/model/scripture_reference.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'devotional.freezed.dart';
part 'devotional.g.dart';

@freezed
abstract class DevotionalGroup with _$DevotionalGroup {
  const factory DevotionalGroup({required Map<String, List<Devotional>> data}) =
      _DevotionalGroup;

  factory DevotionalGroup.fromJson(Map<String, dynamic> json) {
    final parsed = json.map(
      (key, value) => MapEntry(
        key,
        (value as List).map((e) => Devotional.fromJson(e)).toList(),
      ),
    );
    return DevotionalGroup(data: parsed);
  }
}

@freezed
abstract class Devotional with _$Devotional {
  const factory Devotional({
    String? id,
    String? title,
    String? content,
    String? authorId,
    String? churchId,
    String? status,
    DateTime? publishedAt,
    String? seriesId,
    String? seriesName,
    @Default([]) List<String> tags,
    @Default([]) List<String> categories,
    @JsonKey(
      name: 'scriptureReferences',
      fromJson: DriftUtils.scriptureReferencesFromJson,
      toJson: DriftUtils.encodeScriptureRefs,
    )
    @Default([])
    List<ScriptureReference> scriptureReferences,
    @Default([]) List<String> images,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Devotional;

  factory Devotional.fromJson(Map<String, dynamic> json) =>
      _$DevotionalFromJson(json);
}
