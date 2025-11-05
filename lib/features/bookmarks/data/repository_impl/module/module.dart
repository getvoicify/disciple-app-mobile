import 'package:disciple/app/core/database/module/app_database_module.dart';
import 'package:disciple/features/bookmarks/data/mapper/module/module.dart';
import 'package:disciple/features/bookmarks/data/repository_impl/bookmark_repo_impl.dart';
import 'package:disciple/features/bookmarks/domain/repository/bookmark_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final bookmarkRepoModule = Provider<IBookmarkRepository>(
  (ref) => BookmarkRepoImpl(
    database: ref.read(appDatabaseProvider),
    bookmarkMapper: ref.read(bookmarkToCompanionMapperProvider),
  ),
);
