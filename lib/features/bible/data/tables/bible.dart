import 'package:drift/drift.dart';

class Versions extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get abbreviation => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class BibleVerses extends Table {
  IntColumn get id => integer().autoIncrement()();
  @JsonKey('version_id')
  TextColumn get versionId =>
      text().references(Versions, #id, onDelete: KeyAction.cascade)();

  @JsonKey('book_name')
  TextColumn get bookName => text()();

  @JsonKey('book')
  IntColumn get book => integer()();

  @JsonKey('chapter')
  IntColumn get chapter => integer()();

  @JsonKey('verse')
  IntColumn get verse => integer()();

  @JsonKey('verse_text')
  TextColumn get verseText => text()();

  @override
  List<String> get customConstraints => [
    'UNIQUE(version_id, book, chapter, verse)',
  ];
}
