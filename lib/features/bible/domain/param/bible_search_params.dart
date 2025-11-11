class BibleSearchParams {
  String? versionId;
  String? bookName;
  int chapter;
  int startVerse;
  int? endVerse;
  String? searchWord;

  BibleSearchParams({
    this.versionId = 'asv',
    this.bookName = 'Genesis',
    this.chapter = 1,
    this.startVerse = 1,
    this.endVerse,
    this.searchWord,
  });

  BibleSearchParams copyWith({
    String? versionId,
    String? bookName,
    int? chapter,
    int? startVerse,
    int? endVerse,
    String? searchWord,
  }) => BibleSearchParams(
    versionId: versionId ?? this.versionId,
    bookName: bookName ?? this.bookName,
    chapter: chapter ?? this.chapter,
    startVerse: startVerse ?? this.startVerse,
    endVerse: endVerse ?? this.endVerse,
    searchWord: searchWord ?? this.searchWord,
  );
}
