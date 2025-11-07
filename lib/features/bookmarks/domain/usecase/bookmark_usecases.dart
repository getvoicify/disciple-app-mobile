import 'package:dio/dio.dart' show CancelToken;
import 'package:disciple/app/core/usecase/disciple_usecase.dart';
import 'package:disciple/features/bookmarks/domain/entity/bookmark_entity.dart';
import 'package:disciple/features/bookmarks/domain/models/bookmark_with_version.dart';
import 'package:disciple/features/bookmarks/domain/service/bookmark_service.dart';

class AddBookmarkUseCaseImpl
    implements DiscipleUseCaseWithRequiredParam<BookmarkEntity, void> {
  final IBookmarkService _service;

  AddBookmarkUseCaseImpl({required IBookmarkService service})
    : _service = service;

  @override
  Future<void> execute({
    required BookmarkEntity parameter,
    CancelToken? cancelToken,
  }) async => await _service.addBookmark(bookmark: parameter);
}

class RemoveBookmarkUseCaseImpl
    implements DiscipleUseCaseWithRequiredParam<BookmarkEntity, void> {
  final IBookmarkService _service;

  RemoveBookmarkUseCaseImpl({required IBookmarkService service})
    : _service = service;

  @override
  Future<void> execute({
    required BookmarkEntity parameter,
    CancelToken? cancelToken,
  }) async => await _service.removeBookmark(bookmark: parameter);
}

class GetBookmarksUseCaseImpl
    implements
        DiscipleStreamUseCaseWithRequiredParam<
          BookmarkEntity,
          List<BookmarkWithVersion>
        > {
  final IBookmarkService _service;

  GetBookmarksUseCaseImpl({required IBookmarkService service})
    : _service = service;

  @override
  Stream<List<BookmarkWithVersion>> execute({
    BookmarkEntity? parameter,
    CancelToken? cancelToken,
  }) => _service.watchBookmarks(bookmark: parameter);
}

class IsBookmarkedUseCaseImpl
    implements DiscipleUseCaseWithRequiredParam<BookmarkEntity, bool> {
  final IBookmarkService _service;

  IsBookmarkedUseCaseImpl({required IBookmarkService service})
    : _service = service;

  @override
  Future<bool> execute({
    required BookmarkEntity parameter,
    CancelToken? cancelToken,
  }) async => await _service.isBookmarked(bookmark: parameter);
}
