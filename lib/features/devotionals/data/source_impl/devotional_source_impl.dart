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
    // final response = await _client.request(
    //   path: ApiPath.devotionals,
    //   requestType: RequestType.get,
    //   cancelToken: cancelToken,
    // );

    await Future.delayed(const Duration(seconds: 2));

    final data = {
      "2024-01-15": [
        {
          "id": "550e8400-e29b-41d4-a716-446655440001",
          "title": "Morning Devotional",
          "content": "Today's devotional content...",
          "authorId": "550e8400-e29b-41d4-a716-446655440002",
          "churchId": "550e8400-e29b-41d4-a716-446655440003",
          "status": "published",
          "publishedAt": "2024-01-15T08:00:00Z",
          "seriesId": "550e8400-e29b-41d4-a716-446655440004",
          "seriesName": "Daily Bread",
          "tags": ["devotional", "morning"],
          "categories": ["spiritual growth"],
          "scriptureReferences": [],
          "image": null,
          "createdAt": "2024-01-15T00:00:00Z",
          "updatedAt": "2024-01-15T00:00:00Z",
        },
      ],
      "2024-01-16": [
        {
          "id": "550e8400-e29b-41d4-a716-446655440005",
          "title": "Evening Reflection",
          "content": "Tonight's reflection...",
          "authorId": "550e8400-e29b-41d4-a716-446655440006",
          "churchId": "550e8400-e29b-41d4-a716-446655440007",
          "status": "published",
          "publishedAt": "2024-01-16T20:00:00Z",
          "seriesId": "550e8400-e29b-41d4-a716-446655440008",
          "seriesName": "Evening Prayer",
          "tags": ["devotional", "evening"],
          "categories": ["prayer"],
          "scriptureReferences": [],
          "image": null,
          "createdAt": "2024-01-16T00:00:00Z",
          "updatedAt": "2024-01-16T00:00:00Z",
        },
      ],
    };
    return DevotionalGroup.fromJson(data);
  }
}
