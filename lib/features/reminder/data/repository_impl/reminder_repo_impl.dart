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

    // Current time reference
    final now = DateTime.now();

    // Filter by status (upcoming / past)
    if (parameter.status != null) {
      if (parameter.status == true) {
        // Upcoming reminders
        select.where((tbl) => tbl.scheduledAt.isBiggerOrEqualValue(now));
      } else {
        // Past reminders
        select.where((tbl) => tbl.scheduledAt.isSmallerThanValue(now));
      }
    }

    // Filter by search text
    if (parameter.searchText != null &&
        parameter.searchText!.trim().isNotEmpty) {
      final q = parameter.searchText!.trim();
      select.where((tbl) => tbl.title.like('$q%'));
    }

    // Sort by most recently updated
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
