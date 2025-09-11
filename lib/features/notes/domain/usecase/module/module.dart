import 'package:disciple/app/core/usecase/disciple_usecase.dart';
import 'package:disciple/features/notes/data/service_impl/module/module.dart';
import 'package:disciple/features/notes/domain/usecase/note_usecases.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final addNoteUseCaseImpl = Provider<DiscipleUseCaseWithRequiredParam>(
  (ref) => AddNoteUseCaseImpl(service: ref.read(noteServiceModule)),
);
