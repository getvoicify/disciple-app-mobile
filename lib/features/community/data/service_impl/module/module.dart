import 'package:disciple/features/community/data/service_impl/church_service_impl.dart';
import 'package:disciple/features/community/domain/service/church_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:disciple/features/community/data/repository_impl/module/module.dart';

final churchServiceModule = Provider<ChurchService>(
  (ref) => ChurchServiceImpl(repository: ref.read(churchRepoModule)),
);
