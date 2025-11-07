import 'package:drift/drift.dart';

class Churches extends Table {
  TextColumn get id => text()(); // UUID
  TextColumn get slug => text()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get logoUrl => text().nullable()();
  TextColumn get coverImageUrl => text().nullable()();
  TextColumn get byline => text().nullable()();
  TextColumn get missionStatement => text().nullable()();
  RealColumn get latitude => real().nullable()();
  RealColumn get longitude => real().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get phoneNumber => text().nullable()();
  TextColumn get websiteUrl => text().nullable()();
  TextColumn get approvalStatus => text().nullable()();
  TextColumn get visibility => text().nullable()();
  TextColumn get createdBy => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  IntColumn get version => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {id};
}

class ChurchAddresses extends Table {
  TextColumn get churchId => text().customConstraint(
    'NOT NULL REFERENCES churches(id) ON DELETE CASCADE',
  )();
  TextColumn get street => text().nullable()();
  TextColumn get city => text().nullable()();
  TextColumn get state => text().nullable()();
  TextColumn get zipCode => text().nullable()();
  TextColumn get country => text().nullable()();

  @override
  Set<Column> get primaryKey => {churchId};
}

class ChurchSocialLinks extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get churchId => text().customConstraint(
    'NOT NULL REFERENCES churches(id) ON DELETE CASCADE',
  )();

  TextColumn get facebook => text().nullable()();
  TextColumn get instagram => text().nullable()();
  TextColumn get twitterX => text().nullable()();
  TextColumn get youtube => text().nullable()();
  TextColumn get tiktok => text().nullable()();

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {churchId}, // enforce 1-to-1 mapping (one row per church)
  ];
}

class ChurchOtherLinks extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get churchId => text().customConstraint(
    'NOT NULL REFERENCES churches(id) ON DELETE CASCADE',
  )();

  TextColumn get url => text()(); // one row per "other" link
}
