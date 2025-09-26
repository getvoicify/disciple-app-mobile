import 'package:disciple/features/bible/data/mapper/bible_mapper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for the BibleToCompanionMapper.
final bibleToCompanionMapperProvider = Provider<BibleToCompanionMapper>(
  (ref) => BibleToCompanionMapper(),
);
