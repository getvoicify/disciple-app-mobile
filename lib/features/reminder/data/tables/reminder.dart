import 'package:drift/drift.dart';

class Reminder extends Table {
  IntColumn get id => integer()();

  TextColumn get title => text().nullable()();

  // Date of reminder
  DateTimeColumn get scheduledAt => dateTime().nullable()();

  // Is Reminder active? (true/false)
  BoolColumn get reminder => boolean().nullable()();

  // ReminderColor fields
  TextColumn get colorLabel => text().nullable()(); // e.g. "Red"
  IntColumn get colorValue => integer().nullable()(); // e.g. 0xFF0000

  // Timestamps
  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now()).nullable()();

  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
