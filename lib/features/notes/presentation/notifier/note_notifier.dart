import 'package:disciple/app/core/database/app_database.dart';
import 'package:disciple/features/notes/domain/entity/note_entity.dart';
import 'package:disciple/features/notes/domain/usecase/module/module.dart';
import 'package:disciple/features/notes/presentation/state/note_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'note_notifier.g.dart';

@Riverpod(keepAlive: true)
class NoteNotifier extends _$NoteNotifier {
  @override
  NoteState build() => const NoteState();

  Future<void> addNote({required NoteEntity entity}) async {
    state = state.copyWith(isAddingNote: true);
    try {
      await ref.read(addNoteUseCaseImpl).execute(parameter: entity);
    } catch (e) {
      state = state.copyWith(isAddingNote: false);
    }
  }

  Stream<List<NoteData>> watchNotes({NoteEntity? entity}) =>
      ref.watch(watchNotesUseCaseImpl).execute(parameter: entity)
          as Stream<List<NoteData>>;
}
