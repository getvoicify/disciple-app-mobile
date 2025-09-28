import 'package:disciple/app/core/http/module/http_client_module.dart';
import 'package:disciple/features/community/data/source_impl/church_source_impl.dart';
import 'package:disciple/features/community/domain/source/church_source.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final churchSourceModule = Provider<ChurchSource>(
  (ref) => ChurchSourceImpl(client: ref.read(networkServiceProvider)),
);
