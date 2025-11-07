import 'package:disciple/app/core/database/app_database.dart';
import 'package:disciple/app/core/database/module/app_database_module.dart';
import 'package:disciple/features/reminder/data/mapper/module/module.dart';
import 'package:disciple/features/reminder/data/mapper/reminder_mapper.dart';
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
    final now = DateTime.now();

    final endOfToday = DateTime(now.year, now.month, now.day, 23, 59, 59);

    // --- Filter by status ---
    if (parameter.status != null) {
      if (parameter.status == true) {
        // Upcoming reminders (today or later)
        select.where((tbl) => tbl.scheduledAt.isBiggerOrEqualValue(now));
      } else {
        // Past reminders (strictly before now)
        select.where((tbl) => tbl.scheduledAt.isSmallerThanValue(now));
      }
    }

    // --- Filter for today's upcoming reminders only ---
    if (parameter.isToday == true) {
      select.where(
        (tbl) =>
            tbl.scheduledAt.isBiggerOrEqualValue(now) &
            tbl.scheduledAt.isSmallerOrEqualValue(endOfToday),
      );
    }

    // --- Filter by search text ---
    if (parameter.searchText != null &&
        parameter.searchText!.trim().isNotEmpty) {
      final q = parameter.searchText!.trim();
      select.where((tbl) => tbl.title.like('$q%'));
    }

    // --- Sort by most recently updated ---
    select.orderBy([(tbl) => OrderingTerm.desc(tbl.updatedAt)]);

    return select.watch();
  }

  @override
  Future<void> deleteReminder({required int id}) async {
    await (_database.delete(
      _database.reminder,
    )..where((tbl) => tbl.id.equals(id))).go();
  }

  @override
  Future<bool> updateReminder({required ReminderEntity entity}) async {
    final companion = _reminderMapper.update(entity);

    final result = await (_database.update(
      _database.reminder,
    )..where((tbl) => tbl.id.equals(entity.id ?? 0))).write(companion);

    return result > 0;
  }
}
