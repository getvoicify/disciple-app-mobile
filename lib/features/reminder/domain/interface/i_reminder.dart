import 'dart:core';

import 'package:disciple/features/reminder/data/model/reminder_model.dart';

/// An interface that defines the common properties between
/// ReminderModel and ReminderEntity.
abstract class IReminder {
  String? get id;
  String? get title;
  DateTime? get scheduledAt;
  bool? get reminder;
  ReminderColor? get color;
  DateTime? get createdAt;
  DateTime? get updatedAt;
  List<DateTime>? get scheduledDates;
}
