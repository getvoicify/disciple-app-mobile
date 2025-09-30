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
    if (bookmark.versionId != null && bookmark.versionId!.isNotEmpty) {
      await _database
          .into(_database.versions)
          .insertOnConflictUpdate(
            VersionsCompanion.insert(
              id: bookmark.versionId!, // required id
              name: bookmark.versionId!.toUpperCase(), // fallback name
              abbreviation: bookmark.versionId!, // fallback abbreviation
            ),
          );
    }

    // 2. Insert the bookmark itself
    final database = _database.into(_database.bookmarks);
    await database.insert(
      _bookmarkMapper.insert(bookmark),
      mode: InsertMode.insertOrIgnore, // optional: avoid duplicate crash
    );
  }

  @override
  Stream<List<BookmarkWithVersion>> watchBookmarks({
    BookmarkEntity? bookmark,
    CancelToken? cancelToken,
  }) {
    _database.select(_database.bookmarks).get().then((bookmarks) {
      print("Bookmarks: ${bookmarks.map((b) => b.versionId)}");
    });

    _database.select(_database.versions).get().then((versions) {
      print("Versions: ${versions.map((v) => v.id)}");
    });

    final query = _database.select(_database.bookmarks).join([
      innerJoin(
        _database.versions,
        _database.versions.id.equalsExp(_database.bookmarks.versionId),
      ),
    ])..orderBy([OrderingTerm.desc(_database.bookmarks.createdAt)]);

    return query.watch().map(
      (rows) => rows
          .map(
            (row) => BookmarkWithVersion(
              bookmark: row.readTable(_database.bookmarks),
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
  }) async {
    final result =
        await (_database.select(_database.bookmarks)..where(
              (tbl) =>
                  tbl.versionId.equals(bookmark.versionId ?? '') &
                  tbl.bookName.equals(bookmark.bookName ?? '') &
                  tbl.chapter.equals(bookmark.chapter ?? 0) &
                  tbl.verse.equals(bookmark.verse ?? 0),
            ))
            .getSingleOrNull();
    return result != null;
  }

  @override
  Future<void> removeBookmark({
    required BookmarkEntity bookmark,
    CancelToken? cancelToken,
  }) async {
    await (_database.delete(_database.bookmarks)..where(
          (tbl) =>
              tbl.versionId.equals(bookmark.versionId ?? '') &
              tbl.bookName.equals(bookmark.bookName ?? '') &
              tbl.chapter.equals(bookmark.chapter ?? 0) &
              tbl.verse.equals(bookmark.verse ?? 0),
        ))
        .go();
  }
}
