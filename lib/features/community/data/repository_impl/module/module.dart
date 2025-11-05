import 'package:disciple/features/community/data/repository_impl/church_repo_impl.dart';
import 'package:disciple/features/community/domain/repository/church_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final churchRepoModule = Provider<ChurchRepository>(
  (ref) => ChurchRepoImpl(ref: ref),
);
