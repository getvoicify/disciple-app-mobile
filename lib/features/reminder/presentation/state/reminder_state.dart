import 'package:freezed_annotation/freezed_annotation.dart';

part 'reminder_state.freezed.dart';
part 'reminder_state.g.dart';

@freezed
abstract class ReminderState with _$ReminderState {
  const factory ReminderState({@Default(false) bool isBusy}) = _ReminderState;
}
