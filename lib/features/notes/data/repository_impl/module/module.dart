import 'package:disciple/app/core/database/module/app_database_module.dart';
import 'package:disciple/app/core/manager/network_manager.dart';
import 'package:disciple/features/notes/data/mapper/module/module.dart';
import 'package:disciple/features/notes/data/repository_impl/note_repo_impl.dart';
import 'package:disciple/features/notes/data/source_impl/module/module.dart';
import 'package:disciple/features/notes/domain/repository/note_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final noteRepoModule = Provider<NoteRepository>(
  (ref) => NoteRepoImpl(
    source: ref.watch(noteSourceModule),
    database: ref.watch(appDatabaseProvider),
    networkManager: ref.watch(networkManagerProvider.notifier),
    noteMapper: ref.watch(noteToCompanionMapperProvider),
  ),
);
