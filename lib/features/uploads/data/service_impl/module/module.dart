import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:disciple/features/uploads/domain/service/upload_service.dart';
import 'package:disciple/features/uploads/data/repository_impl/module/module.dart';
import 'package:disciple/features/uploads/data/service_impl/upload_service_impl.dart';

final uploadServiceModule = Provider<UploadService>(
  (ref) => UploadServiceImpl(repository: ref.read(uploadRepoModule)),
);
