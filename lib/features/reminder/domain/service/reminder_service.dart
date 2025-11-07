import 'package:disciple/app/core/database/app_database.dart';
import 'package:disciple/features/reminder/domain/entity/reminder_entity.dart';
import 'package:disciple/features/reminder/domain/usecase/watch_reminder_usecase.dart';

abstract class ReminderService {
  Future<void> addReminder({required ReminderEntity entity});
  Future<bool> updateReminder({required ReminderEntity entity});
  Future<void> deleteReminder({required int id});
  Stream<List<ReminderData>> watchReminder({
    required WatchReminderParams parameter,
  });
}
