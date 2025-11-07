import 'package:dio/dio.dart' show CancelToken;
import 'package:disciple/app/core/usecase/disciple_usecase.dart';
import 'package:disciple/features/reminder/domain/service/reminder_service.dart';

class DeleteReminderUseCaseImpl
    implements DiscipleUseCaseWithRequiredParam<String, void> {
  final ReminderService _service;

  DeleteReminderUseCaseImpl({required ReminderService service})
    : _service = service;

  @override
  Future<void> execute({required String parameter, CancelToken? cancelToken}) =>
      _service.deleteReminder(id: parameter);
}
