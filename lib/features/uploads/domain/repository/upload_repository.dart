import 'package:disciple/features/uploads/data/model/upload.dart';
import 'package:image_picker/image_picker.dart';

abstract class UploadRepository {
  Future<Upload?> upload({required XFile file});
}
