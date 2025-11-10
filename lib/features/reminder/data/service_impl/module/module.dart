import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:disciple/features/reminder/domain/service/reminder_service.dart';
import 'package:disciple/features/reminder/data/repository_impl/module/module.dart';
import 'package:disciple/features/reminder/data/service_impl/reminder_service_impl.dart';
import 'package:disciple/app/core/manager/notification_manager.dart';

final reminderServiceModule = Provider<ReminderService>(
  (ref) => ReminderServiceImpl(
    repository: ref.read(reminderRepoModule),
    notificationManager: ref.read(notificationManagerProvider),
  ),
);
