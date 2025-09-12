import 'package:disciple/app/core/usecase/disciple_usecase.dart';
import 'package:disciple/features/notes/data/service_impl/module/module.dart';
import 'package:disciple/features/notes/domain/usecase/get_note_by_id_usecase.dart';
import 'package:disciple/features/notes/domain/usecase/note_usecases.dart';
import 'package:disciple/features/notes/domain/usecase/watch_notes_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final addNoteUseCaseImpl = Provider<DiscipleUseCaseWithRequiredParam>(
  (ref) => AddNoteUseCaseImpl(service: ref.read(noteServiceModule)),
);

final watchNotesUseCaseImpl = Provider<DiscipleStreamUseCaseWithRequiredParam>(
  (ref) => WatchNotesUseCaseImpl(service: ref.read(noteServiceModule)),
);

final getNoteByIdUseCaseImpl = Provider<DiscipleUseCaseWithRequiredParam>(
  (ref) => GetNoteByIdUseCaseImpl(service: ref.read(noteServiceModule)),
);
