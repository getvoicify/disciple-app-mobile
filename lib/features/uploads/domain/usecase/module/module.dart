import 'package:disciple/app/core/usecase/disciple_usecase.dart';
import 'package:disciple/features/uploads/data/service_impl/module/module.dart';
import 'package:disciple/features/uploads/domain/usecase/upload_media_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final uploadMediaUseCaseImpl = Provider<DiscipleUseCaseWithRequiredParam>(
  (ref) => UploadMediaUseCaseImpl(service: ref.read(uploadServiceModule)),
);
