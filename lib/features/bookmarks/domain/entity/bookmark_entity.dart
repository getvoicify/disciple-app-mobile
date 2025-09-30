import 'package:disciple/features/bookmarks/domain/interface/i_bookmark.dart';

class BookmarkEntity implements IBookmark {
  @override
  final String? id;

  @override
  final int bibleVerseId;

  BookmarkEntity({this.id, required this.bibleVerseId});
}
