class PostEntity {
  final String? churchId;
  final String? authorId;
  final String? status;
  final String? seriesId;
  final String? startDate;
  final String? endDate;
  final String? tags;
  final String? categories;
  final String? scriptureBook;
  final String? scriptureChapter;
  final String? scriptureVerse;

  PostEntity({
    this.churchId,
    this.authorId,
    this.status,
    this.seriesId,
    this.startDate,
    this.endDate,
    this.tags,
    this.categories,
    this.scriptureBook,
    this.scriptureChapter,
    this.scriptureVerse,
  });

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = {};

    if (churchId != null || churchId!.isNotEmpty) {
      map.addAll({'churchId': churchId});
    }

    if (authorId != null) {
      map.addAll({'authorId': authorId});
    }

    if (status != null) {
      map.addAll({'status': status});
    }

    if (seriesId != null) {
      map.addAll({'seriesId': seriesId});
    }

    if (startDate != null || startDate!.isNotEmpty) {
      map.addAll({'startDate': startDate});
    }

    if (endDate != null || endDate!.isNotEmpty) {
      map.addAll({'endDate': endDate});
    }

    if (tags != null || tags!.isNotEmpty) {
      map.addAll({'tags': tags});
    }

    if (categories != null || categories!.isNotEmpty) {
      map.addAll({'categories': categories});
    }

    if (scriptureBook != null || scriptureBook!.isNotEmpty) {
      map.addAll({'scripture.book': scriptureBook});
    }

    if (scriptureChapter != null || scriptureChapter!.isNotEmpty) {
      map.addAll({'scripture.chapter': scriptureChapter});
    }

    if (scriptureVerse != null || scriptureVerse!.isNotEmpty) {
      map.addAll({'scripture.verse': scriptureVerse});
    }

    return map;
  }
}
