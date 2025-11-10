import 'package:disciple/app/config/app_logger.dart';
import 'package:disciple/app/core/database/app_database.dart';
import 'package:disciple/app/core/manager/notification_manager.dart';
import 'package:disciple/features/reminder/domain/entity/reminder_entity.dart';
import 'package:disciple/features/reminder/domain/repository/reminder_repository.dart';
import 'package:disciple/features/reminder/domain/service/reminder_service.dart';
import 'package:disciple/features/reminder/domain/usecase/watch_reminder_usecase.dart';

class ReminderServiceImpl implements ReminderService {
  final _logger = getLogger('ReminderServiceImpl');

  final ReminderRepository _repository;

  final NotificationManager _notificationManager;

  ReminderServiceImpl({
    required ReminderRepository repository,
    required NotificationManager notificationManager,
  }) : _repository = repository,
       _notificationManager = notificationManager;

  @override
  Future<void> addReminder({required ReminderEntity entity}) async {
    try {
      final now = DateTime.now();
      final time = entity.scheduledAt ?? now;
      final targetDates = (entity.scheduledDates?.isNotEmpty ?? false)
          ? entity.scheduledDates!
          : [entity.scheduledAt!];

      // Build reminders with correct times and filter out past dates
      final reminders = targetDates
          .map((date) {
            final scheduledDateTime = DateTime(
              date.year,
              date.month,
              date.day,
              time.hour,
              time.minute,
            );
            return entity.copyWith(scheduledAt: scheduledDateTime);
          })
          .where((r) => r.scheduledAt!.isAfter(now))
          .toList();

      const chunkSize = 5; // Adjustable concurrency limit

      for (var i = 0; i < reminders.length; i += chunkSize) {
        final chunk = reminders.skip(i).take(chunkSize);

        // Run DB + notification operations in parallel per batch
        await Future.wait(
          chunk.map((r) async {
            await _repository.addReminder(entity: r);

            if (r.reminder ?? false) {
              await _notificationManager.scheduleNotificationAt(
                id: r.id ?? 0,
                body: r.title ?? '',
                scheduledAt: r.scheduledAt!,
              );
            }
          }),
        );
      }

      _logger.i(
        "${reminders.length} reminder(s) saved and scheduled successfully.",
      );
    } catch (e, st) {
      _logger.e('Error adding reminder: $e\n$st');
      rethrow;
    }
  }

  @override
  Stream<List<ReminderData>> watchReminder({
    required WatchReminderParams parameter,
  }) => _repository.watchReminder(parameter: parameter);

  @override
  Future<void> deleteReminder({required int id}) async {
    try {
      await Future.wait([
        _repository.deleteReminder(id: id),
        _notificationManager.cancel(id),
      ]);
    } catch (e, st) {
      _logger.e('Error deleting reminder: $e\n$st');
      rethrow;
    }
  }

  @override
  Future<bool> updateReminder({required ReminderEntity entity}) async {
    try {
      final result = _repository.updateReminder(entity: entity);

      final id = entity.id ?? 0;

      await _notificationManager.cancel(id);
      await _notificationManager.scheduleNotificationAt(
        id: id,
        body: entity.title ?? '',
        scheduledAt: entity.scheduledAt!,
      );

      return result;
    } catch (e, st) {
      _logger.e('Error updating reminder: $e\n$st');
      rethrow;
    }
  }
}
