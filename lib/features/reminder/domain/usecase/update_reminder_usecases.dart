import 'package:dio/dio.dart';
import 'package:disciple/app/core/usecase/disciple_usecase.dart';
import 'package:disciple/features/reminder/domain/entity/reminder_entity.dart';
import 'package:disciple/features/reminder/domain/service/reminder_service.dart';

class UpdateReminderUseCaseImpl
    implements DiscipleUseCaseWithOptionalParam<ReminderEntity, bool> {
  final ReminderService _service;

  UpdateReminderUseCaseImpl({required ReminderService service})
    : _service = service;

  @override
  Future<bool> execute({ReminderEntity? parameter, CancelToken? cancelToken}) =>
      _service.updateReminder(entity: parameter!);
}
