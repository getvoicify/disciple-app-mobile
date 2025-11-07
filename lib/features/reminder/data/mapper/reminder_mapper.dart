import 'package:disciple/app/core/database/app_database.dart';
import 'package:disciple/app/core/database/helpers/drift_helper.dart';
import 'package:disciple/app/core/mapper/mapper.dart';
import 'package:disciple/features/reminder/domain/entity/reminder_entity.dart';
import 'package:drift/drift.dart';

/// A mapper class that implements the generic [Mapper] interface to convert
/// a [ReminderEntity] to a [ReminderCompanion].
class ReminderToCompanionMapper<T extends ReminderEntity>
    implements Mapper<T, ReminderCompanion> {
  @override
  ReminderCompanion insert(T input) => ReminderCompanion(
    id: Value(DriftUtils.generateUniqueId(input.id)),
    title: Value(input.title),
    scheduledAt: Value(DriftUtils.timestampOrNow(input.scheduledAt)),
    reminder: Value(input.reminder),
    colorLabel: Value(input.color?.label),
    colorValue: Value(input.color?.color),
    createdAt: Value(DriftUtils.timestampOrNow(input.createdAt)),
    updatedAt: Value(DriftUtils.timestampOrNow(input.updatedAt)),
  );

  @override
  ReminderCompanion update(T input) => ReminderCompanion(
    id: Value(input.id!),
    title: Value(input.title),
    scheduledAt: Value(DriftUtils.timestampOrNow(input.scheduledAt)),
    reminder: Value(input.reminder),
    colorLabel: Value(input.color?.label),
    colorValue: Value(input.color?.color),
    updatedAt: Value(DriftUtils.timestampOrNow(input.updatedAt)),
  );
}
