import 'package:disciple/app/core/http/module/http_client_module.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:disciple/features/devotionals/data/source_impl/devotional_source_impl.dart';
import 'package:disciple/features/devotionals/domain/source/devotional_source.dart';

final devotionalSourceModule = Provider<DevotionalSource>(
  (ref) => DevotionalSourceImpl(client: ref.read(networkServiceProvider)),
);
