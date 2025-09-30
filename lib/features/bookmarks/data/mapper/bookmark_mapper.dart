import 'package:disciple/app/core/database/app_database.dart';
import 'package:disciple/app/core/database/helpers/drift_helper.dart';
import 'package:disciple/app/core/mapper/mapper.dart';
import 'package:disciple/features/bookmarks/domain/interface/i_bookmark.dart';

class BookmarkToCompanionMapper<T extends IBookmark>
    implements Mapper<T, BookmarksCompanion> {
  @override
  BookmarksCompanion insert(T input) => BookmarksCompanion.insert(
    id: DriftUtils.generateId(input.id),
    bibleVerseId: input.bibleVerseId,
  );

  @override
  BookmarksCompanion update(T input) => BookmarksCompanion.insert(
    id: DriftUtils.generateId(input.id),
    bibleVerseId: input.bibleVerseId,
  );
}
