class BibleSearchParams {
  String? versionId;
  String? bookName;
  int chapter;
  int startVerse;
  int? endVerse;
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
