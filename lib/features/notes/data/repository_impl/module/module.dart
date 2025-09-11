import 'package:disciple/features/notes/data/repository_impl/note_repo_impl.dart';
import 'package:disciple/features/notes/data/source_impl/module/module.dart';
import 'package:disciple/features/notes/domain/repository/note_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final noteRepoModule = Provider<NoteRepository>(
  (ref) => NoteRepoImpl(source: ref.read(noteSourceModule)),
);
