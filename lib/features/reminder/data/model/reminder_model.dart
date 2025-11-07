import 'package:disciple/features/reminder/domain/interface/i_reminder.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'reminder_model.freezed.dart';
part 'reminder_model.g.dart';

@freezed
abstract class Reminder with _$Reminder implements IReminder {
  const factory Reminder({
    int? id,
    String? title,
    DateTime? scheduledAt,
    bool? reminder,
    ReminderColor? color,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<DateTime>? scheduledDates,
  }) = _Reminder;

  factory Reminder.fromJson(Map<String, dynamic> json) =>
      _$ReminderFromJson(json);
}

@freezed
abstract class ReminderColor with _$ReminderColor {
  const factory ReminderColor({String? label, int? color}) = _ReminderColor;

  factory ReminderColor.fromJson(Map<String, dynamic> json) =>
      _$ReminderColorFromJson(json);
}
