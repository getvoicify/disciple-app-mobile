import 'package:dio/dio.dart';
import 'package:disciple/app/core/database/app_database.dart';
import 'package:disciple/features/bookmarks/domain/entity/bookmark_entity.dart';
import 'package:disciple/features/bookmarks/domain/models/bookmark_with_version.dart';
import 'package:disciple/features/bookmarks/domain/usecase/module/module.dart';
import 'package:disciple/features/bookmarks/presentation/state/bookmark_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'bookmark_notifier.g.dart';

@Riverpod(keepAlive: true)
class BookmarkNotifier extends _$BookmarkNotifier {
  @override
  BookmarkState build() => const BookmarkState();

  Future<void> addBookmark({
    required BookmarkEntity bookmark,
    CancelToken? cancelToken,
  }) async {
    state = state.copyWith(isAddingBookmark: true);
    try {
      await ref
          .read(addBookmarkUseCaseImpl)
          .execute(parameter: bookmark, cancelToken: cancelToken);
    } catch (_) {
    } finally {
      state = state.copyWith(isAddingBookmark: false);
    }
  }

  Stream<List<BookmarkWithVersion>> getBookmarks({
    BookmarkEntity? bookmark,
    CancelToken? cancelToken,
  }) =>
      ref
              .read(getBookmarksUseCaseImpl)
              .execute(parameter: bookmark, cancelToken: cancelToken)
          as Stream<List<BookmarkWithVersion>>;
}
