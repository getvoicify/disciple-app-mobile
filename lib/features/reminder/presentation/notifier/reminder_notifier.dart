import 'package:disciple/app/core/database/app_database.dart';
import 'package:disciple/features/reminder/domain/entity/reminder_entity.dart';
import 'package:disciple/features/reminder/domain/usecase/module/module.dart';
import 'package:disciple/features/reminder/domain/usecase/watch_reminder_usecase.dart';
import 'package:disciple/features/reminder/presentation/state/reminder_state.dart';
import 'package:disciple/widgets/calendar/module/calendar_notifier.dart';
import 'package:disciple/widgets/notification/notification_tray.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'reminder_notifier.g.dart';

@Riverpod(keepAlive: true)
class ReminderNotifier extends _$ReminderNotifier {
  @override
  ReminderState build() => const ReminderState();

  Future<void> addReminder({required ReminderEntity entity}) async {
    state = state.copyWith(isAddingReminder: true);
    try {
      await ref.read(addReminderUseCaseImpl).execute(parameter: entity);
      triggerNotificationTray("Reminder added successfully");
    } catch (e) {
      triggerNotificationTray(e.toString(), error: true);
    } finally {
      ref.read(calendarProvider.notifier).reset();
      state = state.copyWith(isAddingReminder: false);
    }
  }

  Stream<List<ReminderData>> watchReminder({
    bool? status,
    String? searchText,
  }) =>
      ref
              .watch(watchReminderUseCaseImpl)
              .execute(
                parameter: WatchReminderParams(
                  status: status,
                  searchText: searchText,
                ),
              )
          as Stream<List<ReminderData>>;
}
