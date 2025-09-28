import 'package:dio/dio.dart';
import 'package:disciple/app/core/http/api_path.dart';
import 'package:disciple/app/core/http/app_http_client.dart';
import 'package:disciple/features/uploads/data/model/upload.dart';
import 'package:disciple/features/uploads/domain/source/upload_source.dart';
import 'package:image_picker/image_picker.dart';

class UploadSourceImpl implements UploadSource {
  final AppHttpClient _client;

  UploadSourceImpl({required AppHttpClient client}) : _client = client;

  @override
  Future<Upload?> upload({required XFile file}) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        file.path,
        filename: file.path.split('/').last,
      ),
    });

    final response = await _client.request(
      path: ApiPath.mediaUpload,
      requestType: RequestType.upload,
      formData: formData,
    );

    final result = response.data as Map<String, dynamic>;
    return Upload.fromJson(result['media'] as Map<String, dynamic>);
  }
}
