import 'package:dio/dio.dart';
import 'package:disciple/app/core/usecase/disciple_usecase.dart';
import 'package:disciple/features/reminder/data/model/reminder_model.dart';
import 'package:disciple/features/reminder/domain/entity/reminder_entity.dart';
import 'package:disciple/features/reminder/domain/service/reminder_service.dart';

class UpdateReminderByIdUseCaseImpl
    implements DiscipleUseCaseWithRequiredParam<ReminderEntity, Reminder> {
  final ReminderService _service;

  UpdateReminderByIdUseCaseImpl({required ReminderService service})
    : _service = service;

  @override
  Future<Reminder> execute({
    required ReminderEntity parameter,
    CancelToken? cancelToken,
  }) async => await _service.updateReminder(entity: parameter);
}
