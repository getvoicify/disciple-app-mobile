import 'package:dio/dio.dart';
import 'package:disciple/app/core/usecase/disciple_usecase.dart';
import 'package:disciple/features/reminder/data/model/reminder_model.dart';
import 'package:disciple/features/reminder/domain/service/reminder_service.dart';

class GetReminderByIdUseCaseImpl
    implements DiscipleUseCaseWithRequiredParam<String, Reminder?> {
  final ReminderService _service;

  GetReminderByIdUseCaseImpl({required ReminderService service})
    : _service = service;

  @override
  Future<Reminder?> execute({
    required String parameter,
    CancelToken? cancelToken,
  }) async => await _service.getReminderById(id: parameter);
}
