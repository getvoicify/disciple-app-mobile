import 'package:dio/dio.dart';
import 'package:disciple/app/common/app_strings.dart';
import 'package:disciple/features/bookmarks/domain/entity/bookmark_entity.dart';
import 'package:disciple/features/bookmarks/domain/models/bookmark_with_version.dart';
import 'package:disciple/features/bookmarks/domain/usecase/module/module.dart';
import 'package:disciple/features/bookmarks/presentation/state/bookmark_state.dart';
import 'package:disciple/widgets/notification/notification_tray.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'bookmark_notifier.g.dart';

final bookmarkSearchProvider = StateProvider<String>((ref) => '');

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
    } catch (_) {
    } finally {
      state = state.copyWith(isAddingBookmark: false);
    }
  }

  Stream<List<BookmarkWithVersion>> getBookmarks({BookmarkEntity? bookmark}) =>
      ref.read(getBookmarksUseCaseImpl).execute(parameter: bookmark)
          as Stream<List<BookmarkWithVersion>>;
}
