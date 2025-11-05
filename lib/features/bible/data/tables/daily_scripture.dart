import 'package:drift/drift.dart';

class DailyScripture extends Table {
  TextColumn get dateKey => text()();
  IntColumn get verseId => integer()();

  @override
  Set<Column> get primaryKey => {dateKey};
}
