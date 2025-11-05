import 'package:disciple/app/config/app_logger.dart';
import 'package:disciple/app/core/database/app_database.dart';
import 'package:disciple/app/utils/extension.dart';
import 'package:disciple/features/reminder/data/model/reminder_model.dart';
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
      final dates = entity.scheduledDates;
      if (dates == null || dates.isEmpty) return;

      final time = entity.scheduledAt ?? DateTime.now();

      for (final date in dates) {
        final scheduledDateTime = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );

        final reminder = entity.copyWith(scheduledAt: scheduledDateTime);

        await _repository.addReminder(entity: reminder);
      }

      _logger.i('Reminders added successfully');
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
    // TODO: implement deleteReminder
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
  Future<Reminder> updateReminder({required ReminderEntity entity}) {
    // TODO: implement updateReminder
    throw UnimplementedError();
  }
}
