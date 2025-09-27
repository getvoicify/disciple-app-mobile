import 'package:disciple/app/core/http/module/http_client_module.dart';
import 'package:disciple/features/uploads/data/source_impl/upload_source_impl.dart';
import 'package:disciple/features/uploads/domain/source/upload_source.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final uploadSourceModule = Provider<UploadSource>(
  (ref) => UploadSourceImpl(client: ref.read(networkServiceProvider)),
);
