import 'package:disciple/app/core/database/app_database.dart';
import 'package:disciple/app/core/database/module/app_database_module.dart';
import 'package:disciple/features/notes/domain/entity/note_entity.dart';
import 'package:disciple/features/reminder/data/mapper/module/module.dart';
import 'package:disciple/features/reminder/data/mapper/reminder_mapper.dart';
import 'package:disciple/features/reminder/data/model/reminder_model.dart';
import 'package:disciple/features/reminder/domain/entity/reminder_entity.dart';
import 'package:disciple/features/reminder/domain/repository/reminder_repository.dart';
import 'package:disciple/features/reminder/domain/usecase/watch_reminder_usecase.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReminderRepoImpl implements ReminderRepository {
  final AppDatabase _database;
  final ReminderToCompanionMapper _reminderMapper;

  final Ref ref;

  ReminderRepoImpl({required this.ref})
    : _database = ref.watch(appDatabaseProvider),
      _reminderMapper = ref.watch(reminderToCompanionMapperProvider);

  @override
  Future<int> addReminder({required ReminderEntity entity}) async =>
      await _database
          .into(_database.reminder)
          .insert(_reminderMapper.insert(entity));

  @override
  Stream<List<ReminderData>> watchReminder({
    required WatchReminderParams parameter,
  }) {
    final select = _database.select(_database.reminder);

    // if (parameter.query != null && (parameter.query ?? '').isNotEmpty) {
    //   select.where((tbl) => tbl.title.like('${parameter.query}%'));
    // }

    select.orderBy([(tbl) => OrderingTerm.desc(tbl.updatedAt)]);

    return select.watch();
  }

  @override
  Future<void> deleteNote({required String id}) {
    // TODO: implement deleteNote
    throw UnimplementedError();
  }

  @override
  Future<Reminder?> getReminderById({required String id}) {
    // TODO: implement getReminderById
    throw UnimplementedError();
  }

  @override
  Future<List<Reminder>> getReminders() {
    // TODO: implement getReminders
    throw UnimplementedError();
  }

  @override
  Future<Reminder> updateReminder({required NoteEntity entity}) {
    // TODO: implement updateReminder
    throw UnimplementedError();
  }
}
