import 'package:disciple/app/core/database/app_database.dart';
import 'package:disciple/app/core/database/module/app_database_module.dart';
import 'package:disciple/app/core/manager/network_manager.dart';
import 'package:disciple/app/utils/extension.dart';
import 'package:disciple/features/notes/data/mapper/module/module.dart';
import 'package:disciple/features/notes/data/mapper/note_mapper.dart';
import 'package:disciple/features/notes/data/source_impl/module/module.dart';
import 'package:disciple/features/notes/domain/entity/note_entity.dart';
import 'package:disciple/features/notes/domain/repository/note_repository.dart';
import 'package:disciple/features/notes/domain/source/note_source.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NoteRepoImpl implements NoteRepository {
  final NoteSource _source;
  final AppDatabase _database;
  final NetworkManager _networkManager;
  final NoteToCompanionMapper _noteMapper;

  final Ref ref;

  NoteRepoImpl({required this.ref})
    : _source = ref.watch(noteSourceModule),
      _database = ref.watch(appDatabaseProvider),
      _networkManager = ref.watch(networkManagerProvider.notifier),
      _noteMapper = ref.watch(noteToCompanionMapperProvider);

  @override
  Future<int> addNote({required NoteEntity entity}) async {
    final database = _database.into(_database.note);

    if (_networkManager.isOnline && ref.isloggedIn) {
      final response = await _source.addNote(entity: entity);
      return await database.insert(
        _noteMapper.insert(response, isSynced: true),
      );
    }
    return await database.insert(_noteMapper.insert(entity));
  }

  @override
  Future<bool> updateNote({required NoteEntity entity}) async {
    final companion = _noteMapper.update(entity);

    final updatedCount = await (_database.update(
      _database.note,
    )..where((tbl) => tbl.id.equals(entity.id ?? ''))).write(companion);

    return updatedCount > 0;
  }

  @override
  Future<bool> deleteNote({required String id}) async {
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
  Stream<List<NoteData>> watchNotes({
    int limit = 20,
    int offset = 0,
    String? query,
  }) {
    final select = _database.select(_database.note);

    if (query != null && query.isNotEmpty) {
      // Starts with (uses index on title if created)
      select.where((tbl) => tbl.title.like('$query%'));
    }

    select
      ..orderBy([(tbl) => OrderingTerm.desc(tbl.updatedAt)])
      ..limit(limit, offset: offset);

    return select.watch();
  }
}
