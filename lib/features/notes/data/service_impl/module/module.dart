import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:disciple/features/notes/domain/service/note_service.dart';
import 'package:disciple/features/notes/data/repository_impl/module/module.dart';
import 'package:disciple/features/notes/data/service_impl/note_service_impl.dart';

final noteServiceModule = Provider<NoteService>(
  (ref) => NoteServiceImpl(repository: ref.read(noteRepoModule)),
);
