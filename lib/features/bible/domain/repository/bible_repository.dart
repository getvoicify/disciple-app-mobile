import 'package:disciple/app/core/database/app_database.dart';
import 'package:disciple/features/bible/data/model/chapter_model.dart';
import 'package:disciple/features/bible/domain/param/bible_search_params.dart';

abstract class BibleRepository {
  Future<void> importBibles();
  Future<List<BibleVerse>> searchBibles(BibleSearchParams params);
  Future<List<String>> getBooks(String versionId);
  List<Version> getVersions();
  Future<List<ChapterInfo>> getBookInfo(BibleSearchParams params);
  Future<BibleVerse?> getDailyScripture();
}
