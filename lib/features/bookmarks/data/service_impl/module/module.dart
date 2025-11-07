import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:disciple/features/bookmarks/domain/service/bookmark_service.dart';
import 'package:disciple/features/bookmarks/data/repository_impl/module/module.dart';
import 'package:disciple/features/bookmarks/data/service_impl/bookmark_service_impl.dart';

final bookmarkServiceModule = Provider<IBookmarkService>(
  (ref) => BookmarkServiceImpl(repository: ref.read(bookmarkRepoModule)),
);
