<<<<<<< HEAD
=======
import 'package:disciple/features/bookmarks/data/tables/bookmark.dart';
>>>>>>> b05cc9c14293b73379b299e1f81efe7ebc10826b
import 'package:drift/drift.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';
<<<<<<< HEAD
import 'package:disciple/features/notes/data/model/note.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Note])
class AppDatabase extends _$AppDatabase {
  // After generating code, this class needs to define a `schemaVersion` getter
  // and a constructor telling drift where the database should be stored.
  // These are described in the getting started guide: https://drift.simonbinder.eu/setup/
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  // the LazyDatabase util lets us find the right location for the file async.
  static LazyDatabase _openConnection() => LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));

    // Also work around limitations on old Android versions
=======
import 'package:disciple/features/notes/data/tables/note.dart';
import 'package:disciple/features/bible/data/tables/bible.dart';
import 'package:disciple/features/community/data/tables/churches_table.dart';
import 'package:disciple/features/bible/data/tables/daily_scripture.dart';
import 'package:disciple/features/reminder/data/tables/reminder.dart';

part 'app_database.g.dart';

/// The main Drift database for the app.
///
/// This class defines all tables used in the app and manages the SQLite
/// connection. It also handles database migrations, FTS5 setup for full-text
/// search, and file-based storage for persistent data.
@DriftDatabase(
  tables: [
    Note, // Notes table for user-created notes
    Versions, // Bible versions table
    BibleVerses, // Bible verses table
    Churches, // Churches table
    ChurchAddresses, // Church addresses table
    ChurchSocialLinks, // Social links for churches
    ChurchOtherLinks, // Other links for churches
    Bookmarks, // Bookmarks table
    DailyScripture, // Daily scripture table
    Reminder, // Reminders table
  ],
)
class AppDatabase extends _$AppDatabase {
  /// Creates a new instance of the database.
  ///
  /// If [executor] is provided, it will be used. Otherwise, the default
  /// file-based connection (_openConnection) will be used.
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  /// Current schema version of the database.
  ///
  /// Bump this value whenever a schema change occurs, e.g., adding a new
  /// column or table. Drift will use this to run migrations.
  @override
  int get schemaVersion => 1;

  /// Opens a file-based connection to SQLite stored in the app documents directory.
  ///
  /// Uses `NativeDatabase.createInBackground` for asynchronous I/O.
  /// Applies Android-specific workarounds for older versions.
  static LazyDatabase _openConnection() => LazyDatabase(() async {
    // Get the app documents directory
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'app.sqlite'));

    // Android compatibility for older SQLite versions
>>>>>>> b05cc9c14293b73379b299e1f81efe7ebc10826b
    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }

<<<<<<< HEAD
    // Make sqlite3 pick a more suitable location for temporary files - the
    // one from the system may be inaccessible due to sandboxing.
    final cachebase = (await getTemporaryDirectory()).path;
    // We can't access /tmp on Android, which sqlite3 would try by default.
    // Explicitly tell it about the correct temporary directory.
    sqlite3.tempDirectory = cachebase;

    return NativeDatabase.createInBackground(file);
  });
=======
    // Set a safe temporary directory for SQLite temp storage
    final cachebase = (await getTemporaryDirectory()).path;
    sqlite3.tempDirectory = cachebase;

    // Return a native SQLite database running in the background
    return NativeDatabase.createInBackground(file);
  });

  /// Defines the migration strategy for the database.
  ///
  /// Handles actions when the database is created for the first time, including
  /// creating all tables and initializing FTS5 virtual tables for full-text search.
  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      // Create all tables defined in the database
      await m.createAll();

      // Manually create an FTS5 virtual table for Bible verses
      //
      // - `verse_text` is indexed for full-text search
      // - `content='bible_verses'` links it to the main BibleVerses table
      // - `content_rowid='id'` tells FTS5 which column acts as the primary key
      await customStatement('''
            CREATE VIRTUAL TABLE bible_verses_fts
            USING fts5(verse_text, content='bible_verses', content_rowid='id');
          ''');
    },

    onUpgrade: (m, from, to) async {},
  );
>>>>>>> b05cc9c14293b73379b299e1f81efe7ebc10826b
}
