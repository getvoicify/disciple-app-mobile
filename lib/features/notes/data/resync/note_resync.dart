import 'dart:convert';

import 'package:disciple/app/config/app_logger.dart';
import 'package:disciple/app/core/background/sync_manager.dart';
import 'package:disciple/app/core/database/app_database.dart';
import 'package:disciple/app/core/database/helpers/drift_helper.dart';
import 'package:disciple/app/core/database/module/app_database_module.dart';
import 'package:disciple/features/notes/data/mapper/module/module.dart';
import 'package:disciple/features/notes/data/mapper/note_mapper.dart';
import 'package:disciple/features/notes/data/model/scripture_reference.dart';
import 'package:disciple/features/notes/data/source_impl/module/module.dart';
import 'package:disciple/features/notes/domain/entity/note_entity.dart';
import 'package:disciple/features/notes/domain/source/note_source.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NoteResyncTask implements ResyncTask {
  final _logger = getLogger('NoteResyncTask');

  final AppDatabase _db;
  final NoteSource _source;
  final NoteToCompanionMapper _mapper;

  final Ref ref;

  NoteResyncTask({required this.ref})
    : _db = ref.watch(appDatabaseProvider),
      _source = ref.watch(noteSourceModule),
      _mapper = ref.watch(noteToCompanionMapperProvider);

  @override
  final String taskId = 'note_resync_task';

  @override
  Future<void> run() async {
    final unsynced = await (_db.select(
      _db.note,
    )..where((tbl) => tbl.isSynced.equals(false))).get();

    if (unsynced.isEmpty) {
      _logger.i('No unsynced notes found');
      return;
    }

    for (final NoteData note in unsynced) {
      try {
        final List<dynamic> refsJson = jsonDecode(note.scriptureReferences);

        final List<ScriptureReference> scriptureRefs =
            DriftUtils.scriptureReferencesFromJson(refsJson);

        final List<String> images = List<String>.from(jsonDecode(note.images));

        final response = await _source.addNote(
          entity: NoteEntity(
            title: note.title,
            content: note.content,
            scriptureReferences: scriptureRefs,
            images: images,
          ),
        );

        await (_db.update(_db.note)..where((tbl) => tbl.id.equals(note.id)))
            .write(_mapper.update(response, isSynced: true));
        _logger.i('Synced note: ${note.id}');
      } catch (e) {
        _logger.e('Syncing note failed: $e');
        break;
      }
    }
  }
}
