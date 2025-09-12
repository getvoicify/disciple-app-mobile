import 'package:disciple/app/config/app_logger.dart';
import 'package:disciple/app/core/database/app_database.dart';
import 'package:disciple/features/notes/domain/entity/note_entity.dart';
import 'package:disciple/features/notes/domain/entity/parsed_note_data.dart';
import 'package:disciple/features/notes/domain/repository/note_repository.dart';
import 'package:disciple/features/notes/domain/service/note_service.dart';

class NoteServiceImpl implements NoteService {
  final _logger = getLogger('NoteServiceImpl');

  final NoteRepository _repository;

  NoteServiceImpl({required NoteRepository repository})
    : _repository = repository;

  @override
  Future<void> addNote({required NoteEntity entity}) async {
    try {
      final id = await _repository.addNote(entity: entity);
      _logger.i('Note added successfully with id: $id');
    } catch (e) {
      _logger.e('An error occurred adding note: $e');
      rethrow;
    }
  }

  @override
  Stream<List<NoteData>> watchNotes({required NoteEntity? entity}) =>
      _repository.watchNotes(
        limit: entity?.limit ?? 20,
        offset: entity?.offset ?? 0,
      );

  @override
  Future<ParsedNoteData?> getNoteById({required String id}) async {
    ParsedNoteData? note;

    try {
      final noteData = await _repository.getNoteById(id: id);

      note = ParsedNoteData(noteData);
      _logger.i('Note retrieved successfully with id: $id');
    } catch (e) {
      _logger.e('An error occurred retrieving note: $e');
      rethrow;
    }
    return note;
  }
}
