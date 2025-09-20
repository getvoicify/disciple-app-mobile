import 'package:drift/drift.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';
import 'package:disciple/features/notes/data/model/note.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Note])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  // 🔼 Bump this whenever the schema changes (e.g. new fields added)
  @override
  int get schemaVersion => 2;

  /// ✅ Migration strategy to handle schema changes and safely add new columns
  @override
  MigrationStrategy get migration => MigrationStrategy(
    // Called when creating the database for the first time
    onCreate: (m) async {
      await m.createAll();
    },

    // Called when upgrading from an old schema version
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await transaction(() async {
          await _safeAddColumnIfNotExists(
            tableName: 'note',
            columnName: 'is_synced',
            onAddColumn: () => m.addColumn(note, note.isSynced),
            onUpdateExistingRows: () =>
                customStatement('UPDATE note SET is_synced = 1'),
          );
        });
      }
    },
  );

  /// 🛠️ Generic utility: Safely adds a column only if it does not exist.
  ///
  /// This prevents crashes when re-running migrations or hot restarting.
  ///
  /// - [tableName] - the name of the table (e.g. 'note')
  /// - [columnName] - the column to check/add (e.g. 'is_synced')
  /// - [onAddColumn] - logic to add the column (e.g. `m.addColumn(...)`)
  /// - [onUpdateExistingRows] - optional logic to populate new column in existing rows
  Future<void> _safeAddColumnIfNotExists({
    required String tableName,
    required String columnName,
    required Future<void> Function() onAddColumn,
    Future<void> Function()? onUpdateExistingRows,
  }) async {
    try {
      final columnExists = await customSelect(
        '''
      SELECT COUNT(*) as count FROM sqlite_master
      WHERE type = 'table'
      AND name = ?
      AND sql LIKE ?
      ''',
        variables: [
          Variable.withString(tableName),
          Variable.withString('%$columnName%'),
        ],
      ).getSingle().then((row) => row.read<int>('count') > 0);

      if (!columnExists) {
        await onAddColumn(); // Add the column
        if (onUpdateExistingRows != null) {
          await onUpdateExistingRows(); // Optional: backfill data
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  /// 📦 Async file-based connection to SQLite, stored in app documents directory
  static LazyDatabase _openConnection() => LazyDatabase(() async {
    // Put the database file, called db.sqlite here, into the documents folder
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));

    // Android compatibility for older versions
    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }

    // Set a safe temporary directory location
    final cachebase = (await getTemporaryDirectory()).path;
    sqlite3.tempDirectory = cachebase;

    return NativeDatabase.createInBackground(file);
  });
}
