import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:disciple/features/devotionals/domain/service/devotional_service.dart';
import 'package:disciple/features/devotionals/data/repository_impl/module/module.dart';
import 'package:disciple/features/devotionals/data/service_impl/devotional_service_impl.dart';

final devotionalServiceModule = Provider<DevotionalService>(
  (ref) => DevotionalServiceImpl(repository: ref.read(devotionalRepoModule)),
);
