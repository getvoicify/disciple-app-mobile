import 'package:disciple/app/core/usecase/disciple_usecase.dart';
import 'package:disciple/features/bookmarks/data/service_impl/module/module.dart';
import 'package:disciple/features/bookmarks/domain/usecase/bookmark_usecases.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final addBookmarkUseCaseImpl = Provider<DiscipleUseCaseWithRequiredParam>(
  (ref) => AddBookmarkUseCaseImpl(service: ref.read(bookmarkServiceModule)),
);

final removeBookmarkUseCaseImpl = Provider<DiscipleUseCaseWithRequiredParam>(
  (ref) => RemoveBookmarkUseCaseImpl(service: ref.read(bookmarkServiceModule)),
);

final getBookmarksUseCaseImpl =
    Provider<DiscipleStreamUseCaseWithRequiredParam>(
      (ref) =>
          GetBookmarksUseCaseImpl(service: ref.read(bookmarkServiceModule)),
    );

final isBookmarkedUseCaseImpl = Provider<DiscipleUseCaseWithRequiredParam>(
  (ref) => IsBookmarkedUseCaseImpl(service: ref.read(bookmarkServiceModule)),
);
