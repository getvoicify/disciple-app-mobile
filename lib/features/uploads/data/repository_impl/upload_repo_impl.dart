import 'package:dio/dio.dart';
import 'package:disciple/features/uploads/data/model/upload.dart';
import 'package:disciple/features/uploads/domain/repository/upload_repository.dart';
import 'package:disciple/features/uploads/domain/source/upload_source.dart';
import 'package:image_picker/image_picker.dart';

class UploadRepoImpl implements UploadRepository {
  final UploadSource _source;

  UploadRepoImpl({required UploadSource source}) : _source = source;

  @override
  Future<Upload?> upload({
    required XFile file,
    CancelToken? cancelToken,
  }) async => await _source.upload(file: file, cancelToken: cancelToken);
}
