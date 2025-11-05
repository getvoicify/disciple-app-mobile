import 'package:disciple/features/reminder/data/mapper/reminder_mapper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for the NoteToCompanionMapper.
final reminderToCompanionMapperProvider = Provider<ReminderToCompanionMapper>(
  (ref) => ReminderToCompanionMapper(),
);
