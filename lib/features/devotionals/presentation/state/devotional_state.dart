import 'package:disciple/features/devotionals/data/model/devotional.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'devotional_state.freezed.dart';
part 'devotional_state.g.dart';

@freezed
abstract class DevotionalState with _$DevotionalState {
  const factory DevotionalState({
    @Default(false) bool isLoadingDevotionals,
    @Default([]) List<Devotional> devotionals,
  }) = _DevotionalState;
}
