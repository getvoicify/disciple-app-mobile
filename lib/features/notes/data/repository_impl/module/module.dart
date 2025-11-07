<<<<<<< HEAD
import 'package:disciple/app/core/database/module/app_database_module.dart';
import 'package:disciple/features/notes/data/repository_impl/note_repo_impl.dart';
import 'package:disciple/features/notes/data/source_impl/module/module.dart';
=======
import 'package:disciple/features/notes/data/repository_impl/note_repo_impl.dart';
>>>>>>> b05cc9c14293b73379b299e1f81efe7ebc10826b
import 'package:disciple/features/notes/domain/repository/note_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final noteRepoModule = Provider<NoteRepository>(
<<<<<<< HEAD
  (ref) => NoteRepoImpl(
    source: ref.read(noteSourceModule),
    database: ref.read(appDatabaseProvider),
  ),
=======
  (ref) => NoteRepoImpl(ref: ref),
>>>>>>> b05cc9c14293b73379b299e1f81efe7ebc10826b
);
