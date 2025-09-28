import 'package:disciple/app/common/app_strings.dart';
import 'package:disciple/app/core/database/app_database.dart';
import 'package:disciple/app/core/routes/page_navigator.dart';
import 'package:disciple/features/notes/domain/entity/note_entity.dart';
import 'package:disciple/features/notes/domain/entity/parsed_note_data.dart';
import 'package:disciple/features/notes/domain/usecase/module/module.dart';
import 'package:disciple/features/notes/domain/usecase/watch_notes_usecase.dart';
import 'package:disciple/features/notes/presentation/state/note_state.dart';
import 'package:disciple/widgets/notification/notification_tray.dart';
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
      triggerNotificationTray(AppString.noteAddedSuccessfully);
      PageNavigator.pop();
    } catch (e) {
      triggerNotificationTray(e.toString(), error: true);
    } finally {
      state = state.copyWith(isAddingNote: false);
    }
  }

  Stream<List<NoteData>> watchNotes({String? query, int offset = 0}) =>
      ref
              .watch(watchNotesUseCaseImpl)
              .execute(parameter: WatchNotesParams(query: query))
          as Stream<List<NoteData>>;

  Future<void> getNoteById({required String id}) async {
    state = state.copyWith(isLoadingNote: true);
    try {
      _noteData = await ref.read(getNoteByIdUseCaseImpl).execute(parameter: id);
    } catch (e) {
      triggerNotificationTray(e.toString(), error: true);
    } finally {
      state = state.copyWith(isLoadingNote: false, note: _noteData);
    }
  }

  Future<void> deleteNote({required String id}) async {
    state = state.copyWith(isDeletingNote: true);
    try {
      await ref.read(deleteNoteUseCaseImpl).execute(parameter: id);
      PageNavigator.pop();
    } catch (e) {
      triggerNotificationTray(e.toString(), error: true);
    } finally {
      state = state.copyWith(isDeletingNote: false);
    }
  }

  Future<void> updateNote({required NoteEntity entity}) async {
    state = state.copyWith(isUpdatingNote: true);
    try {
      await ref.read(updateNoteUseCaseImpl).execute(parameter: entity);
      PageNavigator.pop();
    } catch (e) {
      triggerNotificationTray(e.toString(), error: true);
    } finally {
      state = state.copyWith(isUpdatingNote: false);
    }
  }

  Future<void> getNotes({String? query, int offset = 0}) async {
    try {
      await ref
          .read(getNotesUseCaseImpl)
          .execute(
            parameter: WatchNotesParams(query: query, offset: offset),
          );
    } catch (_) {
    } finally {}
  }
}
