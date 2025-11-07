import 'package:dio/dio.dart';
import 'package:disciple/app/core/http/api_path.dart';
import 'package:disciple/app/core/http/app_http_client.dart';
import 'package:disciple/features/devotionals/data/model/devotional.dart';
import 'package:disciple/features/devotionals/domain/source/devotional_source.dart';

class DevotionalSourceImpl implements DevotionalSource {
  final AppHttpClient _client;

  DevotionalSourceImpl({required AppHttpClient client}) : _client = client;

  @override
  Future<DevotionalGroup?> getDevotionals({CancelToken? cancelToken}) async {
    final response = await _client.request(
      path: ApiPath.devotionals,
      requestType: RequestType.get,
      cancelToken: cancelToken,
    );

    return DevotionalGroup.fromJson(response.data as Map<String, dynamic>);
  }
}
