import 'package:disciple/app/core/database/app_database.dart';
import 'package:disciple/app/core/database/module/app_database_module.dart';
import 'package:disciple/app/core/manager/connectivity_manager.dart';
import 'package:disciple/app/utils/extension.dart';
import 'package:disciple/features/notes/data/mapper/module/module.dart';
import 'package:disciple/features/notes/data/mapper/note_mapper.dart';
import 'package:disciple/features/notes/data/source_impl/module/module.dart';
import 'package:disciple/features/notes/domain/entity/note_entity.dart';
import 'package:disciple/features/notes/domain/repository/note_repository.dart';
import 'package:disciple/features/notes/domain/source/note_source.dart';
import 'package:disciple/features/notes/domain/usecase/watch_notes_usecase.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NoteRepoImpl implements NoteRepository {
  final NoteSource _source;
  final AppDatabase _database;
  final ConnectivityManager _connectivityManager;
  final NoteToCompanionMapper _noteMapper;

  final Ref ref;

  NoteRepoImpl({required this.ref})
    : _source = ref.watch(noteSourceModule),
      _database = ref.watch(appDatabaseProvider),
      _connectivityManager = ref.watch(connectivityManagerInstanceProvider),
      _noteMapper = ref.watch(noteToCompanionMapperProvider);

  @override
  Future<int> addNote({required NoteEntity entity}) async {
    final database = _database.into(_database.note);

    if (_connectivityManager.isOnline && ref.isloggedIn) {
      final response = await _source.addNote(entity: entity);
      return await database.insert(
        _noteMapper.insert(response, isSynced: true),
      );
    }
    return await database.insert(_noteMapper.insert(entity));
  }

  @override
  Future<bool> updateNote({required NoteEntity entity}) async {
    final String noteId = entity.id ?? '';
    final database = (_database.update(_database.note)
      ..where((tbl) => tbl.id.equals(noteId)));

    if (_connectivityManager.isOnline && ref.isloggedIn) {
      final response = await _source.updateNote(id: noteId, entity: entity);
      return await database.write(_noteMapper.update(response)) > 0;
    }

    return await database.write(_noteMapper.update(entity, isSynced: false)) >
        0;
  }

  @override
  Future<bool> deleteNote({required String id}) async {
    if (_connectivityManager.isOnline && ref.isloggedIn) {
      await _source.deleteNote(id: id);
    }

    final count = await (_database.delete(
      _database.note,
    )..where((tbl) => tbl.id.equals(id))).go();

    return count > 0;
  }

  @override
  Future<NoteData?> getNoteById({required String id}) async =>
      await (_database.select(
        _database.note,
      )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();

  @override
  Stream<List<NoteData>> watchNotes({WatchNotesParams? params}) {
    final select = _database.select(_database.note);

    if (params?.query != null && (params?.query ?? '').isNotEmpty) {
      select.where((tbl) => tbl.title.like('${params?.query}%'));
    }

    select.orderBy([(tbl) => OrderingTerm.desc(tbl.updatedAt)]);

    return select.watch();
  }

  @override
  Future<void> getNotes({WatchNotesParams? params}) async {
    final remoteNotes = await _source.getNotes(parameter: params);

    if (remoteNotes.isEmpty) return;

    await _database.transaction(() async {
      for (final note in remoteNotes) {
        await _database
            .into(_database.note)
            .insertOnConflictUpdate(_noteMapper.insert(note, isSynced: true));
      }
    });
  }
}
