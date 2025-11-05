import 'package:disciple/features/devotionals/data/repository_impl/devotional_repo_impl.dart';
import 'package:disciple/features/devotionals/data/source_impl/module/module.dart';
import 'package:disciple/features/devotionals/domain/repository/devotional_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final devotionalRepoModule = Provider<DevotionalRepository>(
  (ref) => DevotionalRepoImpl(source: ref.read(devotionalSourceModule)),
);
