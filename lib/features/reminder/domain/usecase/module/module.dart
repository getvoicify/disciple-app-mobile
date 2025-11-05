import 'package:disciple/app/core/usecase/disciple_usecase.dart';
import 'package:disciple/features/reminder/data/service_impl/module/module.dart';
import 'package:disciple/features/reminder/domain/usecase/add_reminder_usecases.dart';
import 'package:disciple/features/reminder/domain/usecase/delete_reminder_by_id_usecase.dart';
import 'package:disciple/features/reminder/domain/usecase/get_reminder_by_id_usecase.dart';
import 'package:disciple/features/reminder/domain/usecase/update_reminder_by_id_usecase.dart';
import 'package:disciple/features/reminder/domain/usecase/watch_reminder_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final addReminderUseCaseImpl = Provider<DiscipleUseCaseWithRequiredParam>(
  (ref) => AddReminderUseCaseImpl(service: ref.read(reminderServiceModule)),
);

final getReminderByIdUseCaseImpl = Provider<DiscipleUseCaseWithRequiredParam>(
  (ref) => GetReminderByIdUseCaseImpl(service: ref.read(reminderServiceModule)),
);

final deleteReminderUseCaseImpl = Provider<DiscipleUseCaseWithRequiredParam>(
  (ref) => DeleteReminderUseCaseImpl(service: ref.read(reminderServiceModule)),
);

final updateReminderUseCaseImpl = Provider<DiscipleUseCaseWithRequiredParam>(
  (ref) =>
      UpdateReminderByIdUseCaseImpl(service: ref.read(reminderServiceModule)),
);

final watchReminderUseCaseImpl =
    Provider<DiscipleStreamUseCaseWithRequiredParam>(
      (ref) =>
          WatchReminderUseCaseImpl(service: ref.read(reminderServiceModule)),
    );
