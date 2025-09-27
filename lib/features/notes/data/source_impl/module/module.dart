import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:disciple/features/notes/domain/source/note_source.dart';
import 'package:disciple/features/notes/data/source_impl/note_source_impl.dart';

final noteSourceModule = Provider<NoteSource>(
  (ref) => NoteSourceImpl(),
  // (ref) => NoteSourceImpl(api: ref.watch(noteApiProvider)),
);
