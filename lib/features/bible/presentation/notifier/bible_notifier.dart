import 'package:disciple/app/core/database/app_database.dart';
import 'package:disciple/features/bible/data/model/chapter_model.dart';
import 'package:disciple/features/bible/domain/param/bible_search_params.dart';
import 'package:disciple/features/bible/domain/usecase/module/module.dart';
import 'package:disciple/features/bible/presentation/state/bible_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'bible_notifier.g.dart';

@Riverpod(keepAlive: true)
class BibleNotifier extends _$BibleNotifier {
  @override
  BibleState build() => const BibleState();

  List<BibleVerse> _verses = [];
  List<String> _books = [];
  List<ChapterInfo?> _chapters = [];
  List<Version> _versions = [];
  BibleVerse? _dailyScripture;

  Future<void> importBibles() async =>
      await ref.read(importBibleUseCaseImpl).execute();

  Future<void> searchBibles(BibleSearchParams params) async {
    try {
      _verses = await ref
          .read(searchBibleUseCaseImpl)
          .execute(parameter: params);
    } catch (_) {
    } finally {
      state = state.copyWith(verses: _verses);
    }
  }

  Future<void> getBooks(String versionId) async {
    try {
      _books = await ref
          .read(searchBibleBooksUseCaseImpl)
          .execute(parameter: versionId);
    } catch (_) {
    } finally {
      state = state.copyWith(books: _books);
    }
  }

  Future<void> getVersions() async {
    try {
      _versions = ref.read(getBibleVersionsUseCaseImpl).execute();
    } catch (_) {
    } finally {
      state = state.copyWith(versions: _versions);
    }
  }

  Future<void> searchBibleChapters(BibleSearchParams params) async {
    try {
      _chapters = await ref
          .read(searchBibleChaptersUseCaseImpl)
          .execute(parameter: params);
    } catch (_) {
    } finally {
      state = state.copyWith(chapters: _chapters);
    }
  }

  Future<void> getDailyScripture() async {
    try {
      _dailyScripture = await ref.read(getDailyScriptureUseCaseImpl).execute();
    } catch (_) {
    } finally {
      state = state.copyWith(dailyScripture: _dailyScripture);
    }
  }
}
