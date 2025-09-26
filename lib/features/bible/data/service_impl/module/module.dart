import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:disciple/features/bible/domain/service/bible_service.dart';
import 'package:disciple/features/bible/data/repository_impl/module/module.dart';
import 'package:disciple/features/bible/data/service_impl/bible_service_impl.dart';

final bibleServiceModule = Provider<BibleService>(
  (ref) => BibleServiceImpl(repository: ref.read(bibleRepoModule)),
);
