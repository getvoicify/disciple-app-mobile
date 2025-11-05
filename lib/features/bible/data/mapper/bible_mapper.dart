import 'package:disciple/app/core/database/app_database.dart';
import 'package:disciple/app/core/mapper/mapper.dart';
import 'package:disciple/features/bible/data/model/bible_model.dart';
import 'package:disciple/features/bible/domain/interface/i_bible.dart';
import 'package:drift/drift.dart';

/// A mapper class that implements the generic [Mapper] interface to convert
/// a [BibleModel] to a [NoteCompanion].
class BibleToCompanionMapper<T extends IBible>
    implements Mapper<T, BibleVersesCompanion> {
  @override
  BibleVersesCompanion insert(T input, {String? versionId}) =>
      BibleVersesCompanion(
        bookName: Value(input.bookName ?? ''),
        book: Value(input.book ?? 1),
        chapter: Value(input.chapter ?? 1),
        verse: Value(input.verse ?? 1),
        verseText: Value(input.text ?? ''),
        versionId: Value(versionId ?? ''),
      );

  @override
  BibleVersesCompanion update(T input, {String? versionId}) =>
      BibleVersesCompanion(
        bookName: Value(input.bookName ?? ''),
        book: Value(input.book ?? 1),
        chapter: Value(input.chapter ?? 1),
        verse: Value(input.verse ?? 1),
        verseText: Value(input.text ?? ''),
        versionId: Value(versionId ?? ''),
      );
}
