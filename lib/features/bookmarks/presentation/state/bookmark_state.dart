import 'package:freezed_annotation/freezed_annotation.dart';

part 'bookmark_state.freezed.dart';
part 'bookmark_state.g.dart';

@freezed
abstract class BookmarkState with _$BookmarkState {
  const factory BookmarkState({
    @Default(false) bool isAddingBookmark,
    @Default(false) bool isLoadingBookmark,
    @Default(false) bool isDeletingBookmark,
    @Default(false) bool isUpdatingBookmark,
    @Default(false) bool isLoadingBookmarks,
  }) = _BookmarkState;
}
