import 'package:disciple/app/core/database/module/app_database_module.dart';
import 'package:disciple/features/bible/data/mapper/module/module.dart';
import 'package:disciple/features/bible/data/repository_impl/bible_repo_impl.dart';
import 'package:disciple/features/bible/data/souce_impl/module/module.dart';
import 'package:disciple/features/bible/domain/repository/bible_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final bibleRepoModule = Provider<BibleRepository>(
  (ref) => BibleRepoImpl(
    database: ref.read(appDatabaseProvider),
    source: ref.read(bibleSourceModule),
    bibleMapper: ref.read(bibleToCompanionMapperProvider),
  ),
);
