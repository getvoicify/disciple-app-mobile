import 'package:dio/dio.dart';
import 'package:disciple/app/core/usecase/disciple_usecase.dart';
import 'package:disciple/features/uploads/data/model/upload.dart';
import 'package:disciple/features/uploads/domain/service/upload_service.dart';
import 'package:image_picker/image_picker.dart';

class UploadMediaUseCaseImpl
    implements DiscipleUseCaseWithRequiredParam<XFile, Upload?> {
  final UploadService _service;

  UploadMediaUseCaseImpl({required UploadService service}) : _service = service;

  @override
  Future<Upload?> execute({
    required XFile parameter,
    CancelToken? cancelToken,
  }) async => await _service.upload(file: parameter, cancelToken: cancelToken);
}
