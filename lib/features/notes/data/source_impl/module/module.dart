import 'package:disciple/app/core/http/module/http_client_module.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:disciple/features/notes/domain/source/note_source.dart';
import 'package:disciple/features/notes/data/source_impl/note_source_impl.dart';

final noteSourceModule = Provider<NoteSource>(
  (ref) => NoteSourceImpl(client: ref.read(networkServiceProvider)),
);
