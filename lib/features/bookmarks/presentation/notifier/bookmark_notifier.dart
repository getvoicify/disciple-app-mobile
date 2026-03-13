import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:disciple/app/common/app_strings.dart';
import 'package:disciple/features/bookmarks/domain/entity/bookmark_entity.dart';
import 'package:disciple/features/bookmarks/domain/models/bookmark_with_version.dart';
import 'package:disciple/features/bookmarks/domain/usecase/module/module.dart';
import 'package:disciple/features/bookmarks/presentation/state/bookmark_state.dart';
import 'package:disciple/widgets/notification/notification_tray.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'bookmark_notifier.g.dart';

final bookmarkSearchProvider = StateProvider<String>((ref) => '');

/// Set of bible verse IDs that are currently bookmarked. Use for indicating
/// bookmarked state in the Bible view.
final bookmarkedVerseIdsProvider = StreamProvider<Set<int>>(
  (ref) => ref
      .watch(bookmarkProvider.notifier)
      .getBookmarks()
      .map((list) => list.map((b) => b.bookmark.bibleVerseId).toSet()),
);

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
      triggerNotificationTray(AppString.bookmarkAddedSuccessfully);
    } catch (e, st) {
      debugPrint('Failed to add bookmark: $e');
      debugPrintStack(stackTrace: st);
      triggerNotificationTray(AppString.bookmarkAddFailed);
    } finally {
      state = state.copyWith(isAddingBookmark: false);
    }
  }

  Future<void> removeBookmark({
    required BookmarkEntity bookmark,
    CancelToken? cancelToken,
  }) async {
    state = state.copyWith(isDeletingBookmark: true);
    try {
      await ref
          .read(removeBookmarkUseCaseImpl)
          .execute(parameter: bookmark, cancelToken: cancelToken);
      triggerNotificationTray(AppString.bookmarkRemovedSuccessfully);
    } catch (e, st) {
      debugPrint('Failed to remove bookmark: $e');
      debugPrintStack(stackTrace: st);
      triggerNotificationTray(AppString.bookmarkRemoveFailed);
    } finally {
      state = state.copyWith(isDeletingBookmark: false);
    }
  }

  Stream<List<BookmarkWithVersion>> getBookmarks({BookmarkEntity? bookmark}) =>
      ref.read(getBookmarksUseCaseImpl).execute(parameter: bookmark)
          as Stream<List<BookmarkWithVersion>>;
}
