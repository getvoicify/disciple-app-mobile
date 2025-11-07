import 'package:drift/drift.dart';

class Note extends Table {
  TextColumn get id => text()();

  TextColumn get title => text().withLength(min: 1, max: 255)();

  TextColumn get content => text()();

  TextColumn get scriptureReferences => text()();

  TextColumn get images => text()();

  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now())();

  DateTimeColumn get updatedAt => dateTime().nullable()();

  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
