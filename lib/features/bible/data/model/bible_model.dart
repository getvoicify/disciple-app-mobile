import 'package:disciple/features/bible/domain/interface/i_bible.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'bible_model.freezed.dart';
part 'bible_model.g.dart';

@freezed
abstract class BibleModel with _$BibleModel {
  const factory BibleModel({
    MetaData? metadata,
    @Default([]) List<Verses> verses,
  }) = _BibleModel;
  factory BibleModel.fromJson(Map<String, dynamic> json) =>
      _$BibleModelFromJson(json);
}

@freezed
abstract class MetaData with _$MetaData {
  const factory MetaData({
    String? name,
    String? shortname,
    String? module,
    String? year,
    String? description,
  }) = _MetaData;
  factory MetaData.fromJson(Map<String, dynamic> json) =>
      _$MetaDataFromJson(json);
}

@freezed
abstract class Verses with _$Verses implements IBible {
  const factory Verses({
    @JsonKey(name: 'book_name') String? bookName,
    @Default(1) int book,
    @Default(1) int chapter,
    @Default(1) int verse,
    @Default('') String text,
  }) = _Verses;
  factory Verses.fromJson(Map<String, dynamic> json) => _$VersesFromJson(json);
}
