import 'package:disciple/app/config/app_logger.dart';
import 'package:disciple/app/core/database/app_database.dart';
import 'package:disciple/features/bible/data/model/chapter_model.dart';
import 'package:disciple/features/bible/domain/param/bible_search_params.dart';
import 'package:disciple/features/bible/domain/repository/bible_repository.dart';
import 'package:disciple/features/bible/domain/service/bible_service.dart';

class BibleServiceImpl implements BibleService {
  final _logger = getLogger('BibleServiceImpl');

  final BibleRepository _repository;

  BibleServiceImpl({required BibleRepository repository})
    : _repository = repository;

  @override
  Future<void> importBibles() async {
    try {
      await _repository.importBibles();
    } catch (e) {
      _logger.e('An error occurred importing bibles: $e');
      rethrow;
    }
  }

  @override
  Future<List<BibleVerse>> searchBibles(BibleSearchParams params) async {
    try {
      return await _repository.searchBibles(params);
    } catch (e) {
      _logger.e('An error occurred searching bibles: $e');
      rethrow;
    }
  }

  @override
  Future<List<String>> getBooks(String versionId) async {
    try {
      return await _repository.getBooks(versionId);
    } catch (e) {
      _logger.e('An error occurred searching bibles: $e');
      rethrow;
    }
  }

  @override
  List<Version> getVersions() {
    try {
      return _repository.getVersions();
    } catch (e) {
      _logger.e('An error occurred searching bibles: $e');
      rethrow;
    }
  }

  @override
  Future<List<ChapterInfo>> getBookInfo(BibleSearchParams params) async {
    try {
      return await _repository.getBookInfo(params);
    } catch (e) {
      _logger.e('An error occurred searching bibles: $e');
      rethrow;
    }
  }
}
