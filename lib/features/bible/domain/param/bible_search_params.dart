class BibleSearchParams {
  final String? versionId;
  final String? bookName;
  final int chapter;
  final int startVerse;
  final int? endVerse;
  String? searchWord;

  BibleSearchParams({
    this.versionId = 'kjv',
    this.bookName = 'Genesis',
    this.chapter = 1,
    this.startVerse = 1,
    this.endVerse,
    this.searchWord,
  });
}
