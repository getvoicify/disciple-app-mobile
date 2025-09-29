import 'package:dio/dio.dart';
import 'package:disciple/features/uploads/data/model/upload.dart';
import 'package:image_picker/image_picker.dart';

abstract class UploadService {
  Future<Upload?> upload({required XFile file, CancelToken? cancelToken});
}
