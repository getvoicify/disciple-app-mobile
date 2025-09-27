import 'package:disciple/app/config/app_logger.dart';
import 'package:disciple/features/uploads/data/model/upload.dart';
import 'package:disciple/features/uploads/domain/repository/upload_repository.dart';
import 'package:disciple/features/uploads/domain/service/upload_service.dart';
import 'package:image_picker/image_picker.dart';

class UploadServiceImpl implements UploadService {
  final _logger = getLogger('UploadServiceImpl');

  final UploadRepository _repository;

  UploadServiceImpl({required UploadRepository repository})
    : _repository = repository;

  @override
  Future<Upload?> upload({required XFile file}) async {
    try {
      return await _repository.upload(file: file);
    } catch (e) {
      _logger.e('Upload failed: $e');
      rethrow;
    }
  }
}
