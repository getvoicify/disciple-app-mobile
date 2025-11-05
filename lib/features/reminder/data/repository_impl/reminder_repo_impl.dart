import 'package:disciple/app/core/database/app_database.dart';
import 'package:disciple/app/core/database/module/app_database_module.dart';
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
  Future<void> deleteReminder({required String id}) async {
    await (_database.delete(
      _database.reminder,
    )..where((tbl) => tbl.id.equals(id))).go();
  }

  @override
  Future<bool> updateReminder({required ReminderEntity entity}) async {
    final companion = _reminderMapper.update(entity);

    final result = await (_database.update(
      _database.reminder,
    )..where((tbl) => tbl.id.equals(entity.id ?? ''))).write(companion);

    return result > 0;
  }
}
