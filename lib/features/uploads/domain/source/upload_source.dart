import 'package:disciple/features/uploads/data/model/upload.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';

abstract class UploadSource {
  Future<Upload?> upload({required XFile file});
}
