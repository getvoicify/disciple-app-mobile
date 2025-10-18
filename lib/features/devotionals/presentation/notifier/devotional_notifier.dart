import 'package:dio/dio.dart';
import 'package:disciple/features/devotionals/data/model/devotional.dart';
import 'package:disciple/features/devotionals/domain/usecase/module/module.dart';
import 'package:disciple/features/devotionals/presentation/state/devotional_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'devotional_notifier.g.dart';

@Riverpod(keepAlive: true)
class DevotionalNotifier extends _$DevotionalNotifier {
  @override
  DevotionalState build() => const DevotionalState();

  List<Devotional> _devotionals = [];

  Future<void> getDevotionals({
    DateTime? date,
    CancelToken? cancelToken,
  }) async {
    state = state.copyWith(isLoadingDevotionals: true);
    try {
      _devotionals = await ref
          .read(getDevotionalsUseCaseImpl)
          .execute(parameter: date, cancelToken: cancelToken);
    } catch (_) {
    } finally {
      state = state.copyWith(
        isLoadingDevotionals: false,
        devotionals: _devotionals,
      );
    }
  }
}
