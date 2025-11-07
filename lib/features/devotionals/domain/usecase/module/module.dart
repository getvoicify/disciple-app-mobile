import 'package:disciple/app/core/usecase/disciple_usecase.dart';
import 'package:disciple/features/devotionals/data/service_impl/module/module.dart';
import 'package:disciple/features/devotionals/domain/usecase/get_devotionals_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getDevotionalsUseCaseImpl = Provider<DiscipleUseCaseWithOptionalParam>(
  (ref) =>
      GetDevotionalsUseCaseImpl(service: ref.read(devotionalServiceModule)),
);
