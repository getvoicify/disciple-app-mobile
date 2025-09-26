import 'package:disciple/app/core/database/app_database.dart';
import 'package:disciple/features/bible/data/model/chapter_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'bible_state.freezed.dart';
part 'bible_state.g.dart';

@freezed
abstract class BibleState with _$BibleState {
  const factory BibleState({
    @Default([])
    @JsonKey(includeFromJson: false, includeToJson: false)
    List<BibleVerse> verses,
    @Default([])
    @JsonKey(includeFromJson: false, includeToJson: false)
    List<ChapterInfo?> chapters,
    @Default([])
    @JsonKey(includeFromJson: false, includeToJson: false)
    List<Version> versions,
    @Default([])
    @JsonKey(includeFromJson: false, includeToJson: false)
    List<String> books,
  }) = _BibleState;
}
