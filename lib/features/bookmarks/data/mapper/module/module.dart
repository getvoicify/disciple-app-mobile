import 'package:disciple/features/bookmarks/data/mapper/bookmark_mapper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final bookmarkToCompanionMapperProvider = Provider<BookmarkToCompanionMapper>(
  (ref) => BookmarkToCompanionMapper(),
);
