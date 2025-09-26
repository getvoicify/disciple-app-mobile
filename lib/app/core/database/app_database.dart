import 'package:drift/drift.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';
import 'package:disciple/features/notes/data/tables/note.dart';
import 'package:disciple/features/bible/data/tables/bible.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Note, Versions, BibleVerses])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  // 🔼 Bump this whenever the schema changes (e.g. new fields added)
  @override
  int get schemaVersion => 1;

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
