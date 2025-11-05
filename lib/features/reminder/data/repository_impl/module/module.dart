import 'package:disciple/features/reminder/data/repository_impl/reminder_repo_impl.dart';
import 'package:disciple/features/reminder/domain/repository/reminder_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final reminderRepoModule = Provider<ReminderRepository>(
  (ref) => ReminderRepoImpl(ref: ref),
);
