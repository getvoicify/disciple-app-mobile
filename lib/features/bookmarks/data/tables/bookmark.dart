import 'package:disciple/features/bible/data/tables/bible.dart';
import 'package:drift/drift.dart';

class Bookmarks extends Table {
  TextColumn get id => text()();

  @JsonKey('version_id')
  TextColumn get versionId =>
      text().references(Versions, #id, onDelete: KeyAction.cascade)();

  @JsonKey('book_name')
  TextColumn get bookName => text()();

  @JsonKey('chapter')
  IntColumn get chapter => integer()();

  @JsonKey('verse')
  IntColumn get verse => integer()();

  @JsonKey('created_at')
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
