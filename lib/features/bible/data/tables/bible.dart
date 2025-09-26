import 'package:drift/drift.dart';

class Versions extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get abbreviation => text()();
}

class BibleVerses extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get versionId =>
      text().references(Versions, #id, onDelete: KeyAction.cascade)();
  TextColumn get bookName => text()();
  IntColumn get book => integer()();
  IntColumn get chapter => integer()();
  IntColumn get verse => integer()();
  TextColumn get verseText => text()();

  @override
  List<String> get customConstraints => [
    'UNIQUE(version_id, book, chapter, verse)',
  ];
}
