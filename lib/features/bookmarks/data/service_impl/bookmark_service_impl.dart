import 'package:dio/dio.dart';
import 'package:disciple/app/config/app_logger.dart';
import 'package:disciple/features/bookmarks/domain/entity/bookmark_entity.dart';
import 'package:disciple/features/bookmarks/domain/models/bookmark_with_version.dart';
import 'package:disciple/features/bookmarks/domain/repository/bookmark_repository.dart';
import 'package:disciple/features/bookmarks/domain/service/bookmark_service.dart';

class BookmarkServiceImpl implements IBookmarkService {
  final IBookmarkRepository _repository;

  final _logger = getLogger('BookmarkServiceImpl');

  BookmarkServiceImpl({required IBookmarkRepository repository})
    : _repository = repository;

  @override
  Future<void> addBookmark({
    required BookmarkEntity bookmark,
    CancelToken? cancelToken,
  }) async {
    try {
      await _repository.addBookmark(
        bookmark: bookmark,
        cancelToken: cancelToken,
      );
    } catch (e) {
      _logger.e('Error adding bookmark', error: e);
      rethrow;
    }
  }

  @override
  Stream<List<BookmarkWithVersion>> watchBookmarks({
    BookmarkEntity? bookmark,
    CancelToken? cancelToken,
  }) {
    try {
      return _repository.watchBookmarks(
        bookmark: bookmark,
        cancelToken: cancelToken,
      );
    } catch (e) {
      _logger.e('Error getting bookmarks', error: e);
      rethrow;
    }
  }

  @override
  Future<bool> isBookmarked({
    required BookmarkEntity bookmark,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _repository.isBookmarked(
        bookmark: bookmark,
        cancelToken: cancelToken,
      );
    } catch (e) {
      _logger.e('Error checking if bookmarked', error: e);
      rethrow;
    }
  }

  @override
  Future<void> removeBookmark({
    required BookmarkEntity bookmark,
    CancelToken? cancelToken,
  }) async {
    try {
      await _repository.removeBookmark(
        bookmark: bookmark,
        cancelToken: cancelToken,
      );
    } catch (e) {
      _logger.e('Error removing bookmark', error: e);
      rethrow;
    }
  }
}
