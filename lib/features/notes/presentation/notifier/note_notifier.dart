import 'package:disciple/app/core/database/app_database.dart';
import 'package:disciple/features/notes/domain/entity/note_entity.dart';
import 'package:disciple/features/notes/domain/entity/parsed_note_data.dart';
import 'package:disciple/features/notes/domain/usecase/module/module.dart';
import 'package:disciple/features/notes/presentation/state/note_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'note_notifier.g.dart';

@Riverpod(keepAlive: true)
class NoteNotifier extends _$NoteNotifier {
  @override
  NoteState build() => const NoteState();

  ParsedNoteData? _noteData;

  Future<void> addNote({required NoteEntity entity}) async {
    state = state.copyWith(isAddingNote: true);
    try {
      await ref.read(addNoteUseCaseImpl).execute(parameter: entity);
    } catch (_) {
    } finally {
      state = state.copyWith(isAddingNote: false);
    }
  }

  Stream<List<NoteData>> watchNotes({NoteEntity? entity}) =>
      ref.watch(watchNotesUseCaseImpl).execute(parameter: entity)
          as Stream<List<NoteData>>;

  Future<void> getNoteById({required String id}) async {
    state = state.copyWith(isLoadingNote: true);
    try {
      _noteData = await ref.read(getNoteByIdUseCaseImpl).execute(parameter: id);
    } catch (_) {
    } finally {
      state = state.copyWith(isLoadingNote: false, note: _noteData);
    }
  }
}
