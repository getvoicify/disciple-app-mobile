<<<<<<< HEAD
import 'package:disciple/features/notes/data/api/module/note_api_provider.dart';
=======
import 'package:disciple/app/core/http/module/http_client_module.dart';
>>>>>>> b05cc9c14293b73379b299e1f81efe7ebc10826b
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:disciple/features/notes/domain/source/note_source.dart';
import 'package:disciple/features/notes/data/source_impl/note_source_impl.dart';

final noteSourceModule = Provider<NoteSource>(
<<<<<<< HEAD
  (ref) => NoteSourceImpl(api: ref.watch(noteApiProvider)),
=======
  (ref) => NoteSourceImpl(client: ref.read(networkServiceProvider)),
>>>>>>> b05cc9c14293b73379b299e1f81efe7ebc10826b
);
