import 'package:drift/drift.dart';

class Note extends Table {
  /// Primary key – UUID
  TextColumn get id => text()();

  /// Title of the note (limit to 255 chars for optimization)
  TextColumn get title => text().withLength(min: 1, max: 255)();

  /// Main note body
  TextColumn get content => text()();

  /// Scripture references stored as JSON string - using text type
  TextColumn get scriptureReferences => text()();

  /// Image paths/URLs stored as JSON array - using text type
  TextColumn get images => text()();

  /// Creation timestamp
  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now())();

  /// Last update timestamp (nullable until first update)
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
