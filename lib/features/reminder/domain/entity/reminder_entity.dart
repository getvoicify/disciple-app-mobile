import 'package:disciple/features/reminder/data/model/reminder_model.dart';
import 'package:disciple/features/reminder/domain/interface/i_reminder.dart';

class ReminderEntity implements IReminder {
  @override
  int? id;

  @override
  final ReminderColor? color;

  @override
  final DateTime? createdAt;

  @override
  final DateTime? scheduledAt;

  @override
  final bool? reminder;

  @override
  final String? title;

  @override
  final DateTime? updatedAt;

  @override
  final List<DateTime>? scheduledDates;

  ReminderEntity({
    this.id,
    this.color,
    this.createdAt,
    this.scheduledAt,
    this.reminder,
    this.title,
    this.updatedAt,
    this.scheduledDates,
  });

  ReminderEntity copyWith({
    int? id,
    ReminderColor? color,
    DateTime? createdAt,
    DateTime? scheduledAt,
    bool? reminder,
    String? title,
    DateTime? updatedAt,
    List<DateTime>? scheduledDates,
  }) => ReminderEntity(
    id: id ?? this.id,
    color: color ?? this.color,
    createdAt: createdAt ?? this.createdAt,
    scheduledAt: scheduledAt ?? this.scheduledAt,
    reminder: reminder ?? this.reminder,
    title: title ?? this.title,
    updatedAt: updatedAt ?? this.updatedAt,
    scheduledDates: scheduledDates ?? this.scheduledDates,
  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};

    if (id != null) {
      json.addAll({'id': id});
    }

    if (title != null) {
      json.addAll({'title': title});
    }

    if (color != null) {
      json.addAll({'color': color?.toJson()});
    }

    if (scheduledAt != null) {
      json.addAll({'scheduledAt': scheduledAt});
    }

    if (reminder != null) {
      json.addAll({'reminder': reminder});
    }

    if (createdAt != null) {
      json.addAll({'createdAt': createdAt});
    }

    if (updatedAt != null) {
      json.addAll({'updatedAt': updatedAt});
    }

    return json;
  }
}
