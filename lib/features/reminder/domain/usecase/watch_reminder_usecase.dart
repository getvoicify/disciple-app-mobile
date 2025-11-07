import 'package:dio/dio.dart';
import 'package:disciple/app/core/database/app_database.dart';
import 'package:disciple/app/core/usecase/disciple_usecase.dart';
import 'package:disciple/features/reminder/domain/service/reminder_service.dart';

class WatchReminderParams {
  final bool? status;
  final String? searchText;
  final bool? isToday;

  WatchReminderParams({this.status, this.searchText, this.isToday});
}

class WatchReminderUseCaseImpl
    implements
        DiscipleStreamUseCaseWithRequiredParam<
          WatchReminderParams,
          List<ReminderData>
        > {
  final ReminderService _service;

  WatchReminderUseCaseImpl({required ReminderService service})
    : _service = service;

  @override
  Stream<List<ReminderData>> execute({
    required WatchReminderParams parameter,
    CancelToken? cancelToken,
  }) => _service.watchReminder(parameter: parameter);
}
