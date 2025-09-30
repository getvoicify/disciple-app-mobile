import 'package:disciple/features/bookmarks/domain/interface/i_bookmark.dart';

class BookmarkEntity implements IBookmark {
  @override
  String? id;
  @override
  final String? versionId;
  @override
  final String? bookName;
  @override
  final int? chapter;
  @override
  final int? verse;

  BookmarkEntity({
    this.id,
    this.versionId,
    this.bookName,
    this.chapter,
    this.verse,
  });
}
