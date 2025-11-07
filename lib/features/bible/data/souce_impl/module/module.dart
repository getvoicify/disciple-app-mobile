import 'package:disciple/features/bible/data/souce_impl/bible_source_impl.dart';
import 'package:disciple/features/bible/domain/source/bible_source.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final bibleSourceModule = Provider<BibleSource>((ref) => BibleSourceImpl());
