import 'package:disciple/app/config/app_logger.dart';
import 'package:disciple/app/core/database/app_database.dart';
import 'package:disciple/features/notes/domain/entity/note_entity.dart';
import 'package:disciple/features/notes/domain/entity/parsed_note_data.dart';
import 'package:disciple/features/notes/domain/repository/note_repository.dart';
import 'package:disciple/features/notes/domain/service/note_service.dart';
import 'package:disciple/features/notes/domain/usecase/watch_notes_usecase.dart';

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
  Stream<List<NoteData>> watchNotes({WatchNotesParams? parameter}) =>
      _repository.watchNotes(
        limit: parameter?.limit ?? 20,
        offset: parameter?.offset ?? 0,
        query: parameter?.query,
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
