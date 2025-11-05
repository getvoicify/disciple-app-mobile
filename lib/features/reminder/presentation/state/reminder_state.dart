import 'package:freezed_annotation/freezed_annotation.dart';

part 'reminder_state.freezed.dart';
part 'reminder_state.g.dart';

@freezed
abstract class ReminderState with _$ReminderState {
  const factory ReminderState({
    @Default(false) bool isAddingReminder,
    @Default(false) bool isLoadingReminder,
    @Default(false) bool isDeletingReminder,
    @Default(false) bool isUpdatingReminder,
    @Default(false) bool isLoadingReminders,
  }) = _ReminderState;
}
