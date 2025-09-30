import 'package:disciple/app/core/database/app_database.dart';

class BookmarkWithVersion {
  final Bookmark bookmark;
  final BibleVerse verse;
  final Version version;

  BookmarkWithVersion({
    required this.bookmark,
    required this.verse,
    required this.version,
  });
}
