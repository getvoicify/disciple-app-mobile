import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:disciple/features/notes/presentation/state/note_state.dart';

part 'note_notifier.g.dart';

@riverpod
class NoteNotifier extends _$NoteNotifier {
  @override
  NoteState build() => const NoteState();
}
