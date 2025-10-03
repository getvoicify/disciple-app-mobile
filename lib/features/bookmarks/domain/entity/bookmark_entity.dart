import 'package:disciple/features/bookmarks/domain/interface/i_bookmark.dart';

class BookmarkEntity implements IBookmark {
  @override
  final String? id;

  @override
  final int? bibleVerseId;

  String? search;

  BookmarkEntity({this.id, this.bibleVerseId, this.search});
}
