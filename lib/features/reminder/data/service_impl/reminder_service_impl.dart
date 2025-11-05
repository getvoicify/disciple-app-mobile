import 'package:disciple/app/config/app_logger.dart';
import 'package:disciple/app/core/database/app_database.dart';
import 'package:disciple/features/reminder/domain/entity/reminder_entity.dart';
import 'package:disciple/features/reminder/domain/repository/reminder_repository.dart';
import 'package:disciple/features/reminder/domain/service/reminder_service.dart';
import 'package:disciple/features/reminder/domain/usecase/watch_reminder_usecase.dart';

class ReminderServiceImpl implements ReminderService {
  final _logger = getLogger('ReminderServiceImpl');

  final ReminderRepository _repository;

  ReminderServiceImpl({required ReminderRepository repository})
    : _repository = repository;

  @override
  Future<void> addReminder({required ReminderEntity entity}) async {
    try {
      final time = entity.scheduledAt ?? DateTime.now();
      final dates = entity.scheduledDates ?? [];

      // If no date range, just insert the single reminder
      final targetDates = dates.isEmpty ? [entity.scheduledAt!] : dates;

      // Build reminders with correct time
      final reminders = targetDates.map((date) {
        final scheduledDateTime = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );

        return entity.copyWith(scheduledAt: scheduledDateTime);
      }).toList();

      /// TODO: Implement notification reminder
      await Future.wait(
        reminders.map((r) => _repository.addReminder(entity: r)),
      );

      _logger.i("${reminders.length} reminder(s) saved");
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
  Future<void> deleteReminder({required String id}) {
    try {
      return _repository.deleteReminder(id: id);
    } catch (e, st) {
      _logger.e('Error deleting reminder: $e\n$st');
      rethrow;
    }
  }

  @override
  Future<bool> updateReminder({required ReminderEntity entity}) {
    try {
      return _repository.updateReminder(entity: entity);
    } catch (e, st) {
      _logger.e('Error updating reminder: $e\n$st');
      rethrow;
    }
  }
}
