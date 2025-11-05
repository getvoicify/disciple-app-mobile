import 'package:drift/drift.dart';

class ChapterInfo {
  final int chapter;
  final int verseCount;

  ChapterInfo({required this.chapter, required this.verseCount});

  factory ChapterInfo.fromRow(QueryRow row) => ChapterInfo(
    chapter: row.read<int>('chapter'),
    verseCount: row.read<int>('verse_count'),
  );

  Map<String, dynamic> toJson() => {
    'chapter': chapter,
    'verseCount': verseCount,
  };
}

class BookInfo {
  final String versionId;
  final String bookName;
  final List<ChapterInfo> chapters;

  BookInfo({
    required this.versionId,
    required this.bookName,
    required this.chapters,
  });

  Map<String, dynamic> toJson() => {
    'versionId': versionId,
    'bookName': bookName,
    'chapters': chapters.map((x) => x.toJson()).toList(),
  };
}
