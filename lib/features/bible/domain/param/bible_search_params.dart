class BibleSearchParams {
  final String? versionId;
  final String? bookName;
  final int? chapter;
  final int? startVerse;
  final int? endVerse;
  final String? searchWord;

  BibleSearchParams({
    this.versionId,
    this.bookName,
    this.chapter,
    this.startVerse,
    this.endVerse,
    this.searchWord,
  });
}
