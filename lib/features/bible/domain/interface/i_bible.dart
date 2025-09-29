import 'package:drift/drift.dart';

abstract class IBible {
  @JsonKey('book_name')
  String? get bookName;

  @JsonKey('book')
  int? get book;

  @JsonKey('chapter')
  int? get chapter;

  @JsonKey('verse')
  int? get verse;

  @JsonKey('verse_text')
  String? get text;
}
