import 'package:disciple/app/core/database/app_database.dart';
import 'package:disciple/features/reminder/data/model/reminder_model.dart';
import 'package:disciple/features/reminder/domain/entity/reminder_entity.dart';
import 'package:disciple/features/reminder/domain/usecase/watch_reminder_usecase.dart';

abstract class ReminderService {
  Future<void> addReminder({required ReminderEntity entity});
  Future<Reminder> updateReminder({required ReminderEntity entity});
  Future<void> deleteReminder({required String id});
  Future<List<Reminder>> getReminders();
  Future<Reminder?> getReminderById({required String id});
  Stream<List<ReminderData>> watchReminder({
    required WatchReminderParams parameter,
  });
}
