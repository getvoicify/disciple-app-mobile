import 'package:dio/dio.dart';
import 'package:disciple/app/core/usecase/disciple_usecase.dart';
import 'package:disciple/features/reminder/domain/entity/reminder_entity.dart';
import 'package:disciple/features/reminder/domain/service/reminder_service.dart';

class AddReminderUseCaseImpl
    implements DiscipleUseCaseWithRequiredParam<ReminderEntity, void> {
  final ReminderService _service;

  AddReminderUseCaseImpl({required ReminderService service})
    : _service = service;

  @override
  Future<void> execute({
    required ReminderEntity parameter,
    CancelToken? cancelToken,
  }) async => await _service.addReminder(entity: parameter);
}
