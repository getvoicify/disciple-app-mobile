import 'package:disciple/app/core/database/app_database.dart';
import 'package:disciple/features/bible/data/mapper/bible_mapper.dart';
import 'package:disciple/features/bible/data/model/chapter_model.dart';
import 'package:disciple/features/bible/domain/param/bible_search_params.dart';
import 'package:disciple/features/bible/domain/repository/bible_repository.dart';
import 'package:disciple/features/bible/domain/source/bible_source.dart';
import 'package:drift/drift.dart';

class BibleRepoImpl implements BibleRepository {
  final AppDatabase _database;
  final BibleSource _source;
  final BibleToCompanionMapper _bibleMapper;

  BibleRepoImpl({
    required AppDatabase database,
    required BibleSource source,
    required BibleToCompanionMapper bibleMapper,
  }) : _database = database,
       _source = source,
       _bibleMapper = bibleMapper;

  @override
  Future<void> importBibles() async {
    final sources = ['asv', 'kjv', 'web'];
    await Future.wait(
      sources.map((source) => _importBibleVersion(source, 500)),
    );
  }

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

        await _database.batch((batch) {
          batch.insertAll(
            _database.bibleVerses,
            chunk,
            mode: InsertMode.insertOrIgnore,
          );
        });
      }
    });
  }

  @override
  Future<List<BibleVerse>> searchBibles(BibleSearchParams params) async {
    final query = _database.select(_database.bibleVerses)
      ..orderBy([(tbl) => OrderingTerm(expression: tbl.verse)])
      ..where((tbl) {
        final conditions = <Expression<bool>>[];

        // Always filter by version
        if (params.versionId != null && params.versionId!.isNotEmpty) {
          conditions.add(tbl.versionId.equals(params.versionId!));
        }

        // Search mode: use LIKE or FTS5 if available
        if (params.searchWord != null && params.searchWord!.isNotEmpty) {
          conditions.add(tbl.verseText.like('%${params.searchWord!}%'));
        } else {
          if (params.bookName != null && params.bookName!.isNotEmpty) {
            conditions.add(tbl.bookName.equals(params.bookName!));
          }
          if (params.chapter != null) {
            conditions.add(tbl.chapter.equals(params.chapter!));
          }
          if (params.startVerse != null && params.endVerse != null) {
            conditions.add(
              tbl.verse.isBetweenValues(params.startVerse!, params.endVerse!),
            );
          }
        }

        // Combine all filters with AND
        return conditions.reduce((a, b) => a & b);
      });

    return query.get();
  }

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

  @override
  List<Version> getVersions() => const [
    Version(id: 'asv', name: 'ASV', abbreviation: 'ASV'),
    Version(id: 'kjv', name: 'KJV', abbreviation: 'KJV'),
  ];

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
}
