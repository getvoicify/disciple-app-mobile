import 'package:disciple/app/core/usecase/disciple_usecase.dart';
import 'package:disciple/features/bible/data/service_impl/module/module.dart';
import 'package:disciple/features/bible/domain/usecase/get_bible_versions_usecase_impl.dart';
import 'package:disciple/features/bible/domain/usecase/import_bible_usecase_impl.dart';
import 'package:disciple/features/bible/domain/usecase/search_bible_books_usecase_impl.dart';
import 'package:disciple/features/bible/domain/usecase/search_bible_chapters_usecase_impl.dart';
import 'package:disciple/features/bible/domain/usecase/search_bible_usecase_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final importBibleUseCaseImpl = Provider<DiscipleUseCaseWithOutParam>(
  (ref) => ImportBibleUsecaseImpl(service: ref.read(bibleServiceModule)),
);

final searchBibleUseCaseImpl = Provider<DiscipleUseCaseWithRequiredParam>(
  (ref) => SearchBibleUsecaseImpl(service: ref.read(bibleServiceModule)),
);

final searchBibleBooksUseCaseImpl = Provider<DiscipleUseCaseWithRequiredParam>(
  (ref) => SearchBibleBooksUsecaseImpl(service: ref.read(bibleServiceModule)),
);

final getBibleVersionsUseCaseImpl = Provider<DiscipleUseCaseWithOutParam>(
  (ref) => GetBibleVersionsUsecaseImpl(service: ref.read(bibleServiceModule)),
);

final searchBibleChaptersUseCaseImpl =
    Provider<DiscipleUseCaseWithRequiredParam>(
      (ref) =>
          SearchBibleChaptersUsecaseImpl(service: ref.read(bibleServiceModule)),
    );

final getDailyScriptureUseCaseImpl = Provider<DiscipleUseCaseWithOutParam>(
  (ref) => GetDailyScriptureUsecaseImpl(service: ref.read(bibleServiceModule)),
);
