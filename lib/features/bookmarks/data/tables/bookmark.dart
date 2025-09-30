import 'package:disciple/features/bible/data/tables/bible.dart';
import 'package:drift/drift.dart';

class Bookmarks extends Table {
  TextColumn get id => text()();

  @JsonKey('bible_verse_id')
  IntColumn get bibleVerseId =>
      integer().references(BibleVerses, #id, onDelete: KeyAction.cascade)();

  @JsonKey('created_at')
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
