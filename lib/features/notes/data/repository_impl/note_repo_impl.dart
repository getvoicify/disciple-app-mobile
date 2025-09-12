import 'package:disciple/app/core/database/app_database.dart';
import 'package:disciple/features/notes/domain/entity/note_entity.dart';
import 'package:disciple/features/notes/domain/repository/note_repository.dart';
import 'package:disciple/features/notes/domain/source/note_source.dart';
import 'package:drift/drift.dart';

class NoteRepoImpl implements NoteRepository {
  final NoteSource _source;
  final AppDatabase _database;

  NoteRepoImpl({required NoteSource source, required AppDatabase database})
    : _source = source,
      _database = database;

  @override
  Future<int> addNote({required NoteEntity entity}) async =>
      await _database.into(_database.note).insert(entity.toCompanion());

  @override
  Future<NoteData?> updateNote({
    required String id,
    required NoteEntity entity,
  }) async => null;

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
