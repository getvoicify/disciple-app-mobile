import 'dart:math';

import 'package:disciple/app/config/app_logger.dart';
import 'package:disciple/app/core/database/app_database.dart';
import 'package:disciple/features/bible/data/mapper/bible_mapper.dart';
import 'package:disciple/features/bible/data/model/chapter_model.dart';
import 'package:disciple/features/bible/domain/param/bible_search_params.dart';
import 'package:disciple/features/bible/domain/repository/bible_repository.dart';
import 'package:disciple/features/bible/domain/source/bible_source.dart';
import 'package:drift/drift.dart';

/// Implementation of the [BibleRepository] interface using Drift as the
/// database and a [BibleSource] for importing raw Bible data.
///
/// Handles:
/// - Importing Bible versions and verses into the database.
/// - Full-text search via FTS5.
/// - Querying for books, chapters, and verses.
class BibleRepoImpl implements BibleRepository {
  /// Drift database instance for querying and writing data.
  final AppDatabase _database;

  /// Source of Bible data for import (e.g., local JSON or remote API).
  final BibleSource _source;

  /// Mapper to convert raw Bible data to Drift-compatible companions.
  final BibleToCompanionMapper _bibleMapper;

  /// Logger instance scoped to this repository.
  final _logger = getLogger('BibleRepoImpl');

  /// Constructs a new [BibleRepoImpl].
  ///
  /// Requires:
  /// - [database]: Drift database instance.
  /// - [source]: Bible source for import.
  /// - [bibleMapper]: Mapper to convert raw verses to Drift companions.
  BibleRepoImpl({
    required AppDatabase database,
    required BibleSource source,
    required BibleToCompanionMapper bibleMapper,
  }) : _database = database,
       _source = source,
       _bibleMapper = bibleMapper;

  /// Imports all Bible versions into the local database if they do not
  /// already exist.
  ///
  /// Currently supports 'ASV', 'KJV', and 'WEB'. Uses a batch size of 500
  /// verses per insert to improve performance.
  @override
  Future<void> importBibles() async {
    // Check if any Bible versions are already present
    final hasData = await _database
        .select(_database.versions)
        .get()
        .then((list) => list.isNotEmpty);

    if (hasData) {
      _logger.i('Bible data already exists in the database. Skipping import.');
      return;
    }

    // Import each Bible version concurrently
    await Future.wait(
      ['asv', 'kjv', 'web'].map((source) => _importBibleVersion(source, 500)),
    );
  }

  /// Imports a single Bible version into the database in batches.
  ///
  /// - [source]: Identifier of the Bible version (e.g., 'kjv').
  /// - [batchSize]: Number of verses to insert per batch.
  ///
  /// After inserting all verses, rebuilds the FTS5 index for full-text
  /// search.
  Future<void> _importBibleVersion(String source, int batchSize) async {
    final bible = await _source.importBibles(source);
    if (bible == null) return;

    final verses = bible.verses;
    final versionId = bible.metadata?.module ?? '';

    await _database.transaction(() async {
      for (var i = 0; i < verses.length; i += batchSize) {
        final chunk = verses
            .skip(i)
            .take(batchSize)
            .map((verse) => _bibleMapper.insert(verse, versionId: versionId))
            .toList();

        // Batch insert for performance
        await _database.batch((batch) {
          batch.insertAll(
            _database.bibleVerses,
            chunk,
            mode: InsertMode.insertOrIgnore,
          );
        });
      }

      // Rebuild the FTS5 index to reflect newly inserted verses
      await _database.customStatement(
        "INSERT INTO bible_verses_fts(bible_verses_fts) VALUES('rebuild');",
      );
    });
  }

  /// Searches Bible verses using optional filters.
  ///
  /// If [params.searchWord] is provided, performs a full-text search using
  /// FTS5 for faster keyword searches.
  ///
  /// Additional filters supported:
  /// - versionId
  /// - bookName
  /// - chapter
  /// - verse range (startVerse to endVerse)
  ///
  /// Returns a list of [BibleVerse] objects matching the search criteria.
  @override
  Future<List<BibleVerse>> searchBibles(BibleSearchParams params) async {
    // Full-text search path
    if (params.searchWord != null && params.searchWord!.isNotEmpty) {
      final rows = await _database
          .customSelect(
            '''
              SELECT bible_verses.*
              FROM bible_verses
              JOIN bible_verses_fts
                ON bible_verses.id = bible_verses_fts.rowid
              WHERE bible_verses_fts MATCH ?
            ''',
            variables: [Variable.withString(params.searchWord!)],
            readsFrom: {_database.bibleVerses},
          )
          .get();

      return rows.map((row) => BibleVerse.fromJson(row.data)).toList();
    }

    // Standard query path when no searchWord is provided
    final query = _database.select(_database.bibleVerses)
      ..orderBy([(tbl) => OrderingTerm(expression: tbl.verse)])
      ..where((tbl) {
        final conditions = <Expression<bool>>[];

        if (params.versionId != null && params.versionId!.isNotEmpty) {
          conditions.add(tbl.versionId.equals(params.versionId!));
        }

        if (params.bookName != null && params.bookName!.isNotEmpty) {
          conditions.add(tbl.bookName.equals(params.bookName!));
        }

        conditions.add(tbl.chapter.equals(params.chapter));

        if (params.endVerse != null) {
          // If endVerse is provided, get verses between start and end
          conditions.add(
            tbl.verse.isBetweenValues(params.startVerse, params.endVerse!),
          );
        } else {
          // If no endVerse, get all verses from startVerse to the end of the chapter
          conditions.add(tbl.verse.isBiggerOrEqualValue(params.startVerse));
        }

        return conditions.reduce((a, b) => a & b);
      });

    return await query.get();
  }

  /// Retrieves a list of all book names for a given Bible version.
  ///
  /// - [versionId]: The Bible version to query.
  /// Returns a list of book names ordered by canonical book order.
  @override
  Future<List<String>> getBooks(String versionId) async {
    final query = _database.customSelect(
      '''
    SELECT DISTINCT book_name
    FROM bible_verses
    WHERE version_id = ?
    ORDER BY book
    ''',
      variables: [Variable.withString(versionId)],
      readsFrom: {_database.bibleVerses},
    );

    final rows = await query.get();
    return rows.map((row) => row.read<String>('book_name')).toList();
  }

  /// Returns the supported Bible versions.
  ///
  /// Currently hardcoded to ASV and KJV.
  @override
  List<Version> getVersions() => const [
    Version(id: 'asv', name: 'ASV', abbreviation: 'ASV'),
    Version(id: 'kjv', name: 'KJV', abbreviation: 'KJV'),
  ];

  /// Retrieves chapter information for a given book and version.
  ///
  /// Returns a list of [ChapterInfo] objects containing chapter numbers and
  /// verse counts.
  @override
  Future<List<ChapterInfo>> getBookInfo(BibleSearchParams params) async {
    final query = _database.customSelect(
      '''
    SELECT chapter, COUNT(verse) as verse_count
    FROM bible_verses
    WHERE version_id = ? AND book_name = ?
    GROUP BY chapter
    ORDER BY chapter
    ''',
      variables: [
        Variable.withString(params.versionId ?? ''),
        Variable.withString(params.bookName ?? ''),
      ],
      readsFrom: {_database.bibleVerses},
    );

    final rows = await query.get();
    return rows.map((row) => ChapterInfo.fromRow(row)).toList();
  }

  @override
  @override
  Future<BibleVerse?> getDailyScripture() async {
    final today = DateTime.now();
    final todayKey = DateTime(
      today.year,
      today.month,
      today.day,
    ).toIso8601String();

    final cachedVerse = await (_database.customSelect(
      '''
    SELECT v.*
    FROM daily_scripture d
    JOIN bible_verses v ON v.id = d.verse_id
    WHERE d.date_key = ?
    ''',
      variables: [Variable.withString(todayKey)],
      readsFrom: {_database.dailyScripture, _database.bibleVerses},
    )).getSingleOrNull();

    if (cachedVerse != null) {
      return BibleVerse.fromJson(cachedVerse.data);
    }

    final totalRows =
        await (_database.selectOnly(_database.bibleVerses)
              ..addColumns([_database.bibleVerses.id.count()]))
            .map((row) => row.read(_database.bibleVerses.id.count()))
            .getSingle();

    if (totalRows == null || totalRows == 0) return null;

    final random = Random().nextInt(totalRows);

    // Fetch random verse in one query
    final verseRow = await (_database.select(
      _database.bibleVerses,
    )..limit(1, offset: random)).getSingleOrNull();

    if (verseRow != null) {
      // Store only id for tomorrow’s reuse
      await _database
          .into(_database.dailyScripture)
          .insertOnConflictUpdate(
            DailyScriptureCompanion.insert(
              dateKey: todayKey,
              verseId: verseRow.id,
            ),
          );
    }

    return verseRow;
  }
}
