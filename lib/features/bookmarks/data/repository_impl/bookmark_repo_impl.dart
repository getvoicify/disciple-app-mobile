import 'package:dio/dio.dart';
import 'package:disciple/app/core/database/app_database.dart';
import 'package:disciple/features/bookmarks/data/mapper/bookmark_mapper.dart';
import 'package:disciple/features/bookmarks/domain/entity/bookmark_entity.dart';
import 'package:disciple/features/bookmarks/domain/models/bookmark_with_version.dart';
import 'package:disciple/features/bookmarks/domain/repository/bookmark_repository.dart';
import 'package:drift/drift.dart';

class BookmarkRepoImpl implements IBookmarkRepository {
  final AppDatabase _database;
  final BookmarkToCompanionMapper _bookmarkMapper;

  BookmarkRepoImpl({
    required AppDatabase database,
    required BookmarkToCompanionMapper bookmarkMapper,
  }) : _database = database,
       _bookmarkMapper = bookmarkMapper;

  @override
  Future<void> addBookmark({
    required BookmarkEntity bookmark,
    CancelToken? cancelToken,
  }) async {
    // 1. Ensure the version exists
    if (bookmark.versionId.isNotEmpty) {
      await _database
          .into(_database.versions)
          .insertOnConflictUpdate(
            VersionsCompanion.insert(
              id: bookmark.versionId, // required id
              name: bookmark.versionId.toUpperCase(), // fallback name
              abbreviation: bookmark.versionId, // fallback abbreviation
            ),
          );
    }

    // 2. Insert the bookmark itself
    final database = _database.into(_database.bookmarks);
    final result = await database.insert(
      _bookmarkMapper.insert(bookmark),
      mode: InsertMode.insertOrIgnore, // optional: avoid duplicate crash
    );

    print("Bookmark added with ID: $result");
  }

  @override
  Stream<List<BookmarkWithVersion>> watchBookmarks({
    BookmarkEntity? bookmark,
    CancelToken? cancelToken,
  }) {
    final query = _database.select(_database.bookmarks).join([
      innerJoin(
        _database.bibleVerses,
        _database.bibleVerses.id.equalsExp(_database.bookmarks.bibleVerseId),
      ),
      innerJoin(
        _database.versions,
        _database.versions.id.equalsExp(_database.bibleVerses.versionId),
      ),
    ])..orderBy([OrderingTerm.desc(_database.bookmarks.createdAt)]);

    return query.watch().map(
      (rows) => rows
          .map(
            (row) => BookmarkWithVersion(
              bookmark: row.readTable(_database.bookmarks),
              verse: row.readTable(_database.bibleVerses),
              version: row.readTable(_database.versions),
            ),
          )
          .toList(),
    );
  }

  @override
  Future<bool> isBookmarked({
    required BookmarkEntity bookmark,
    CancelToken? cancelToken,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> removeBookmark({
    required BookmarkEntity bookmark,
    CancelToken? cancelToken,
  }) async {
    throw UnimplementedError();
  }
}
