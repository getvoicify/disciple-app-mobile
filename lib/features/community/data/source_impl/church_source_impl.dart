import 'package:dio/dio.dart';
import 'package:disciple/app/core/http/api_path.dart';
import 'package:disciple/app/core/http/app_http_client.dart';
import 'package:disciple/features/community/data/model/church.dart';
import 'package:disciple/features/community/data/model/location.dart';
import 'package:disciple/features/community/data/model/membership.dart';
import 'package:disciple/features/community/domain/entity/church_entity.dart';
import 'package:disciple/features/community/domain/source/church_source.dart';

class ChurchSourceImpl implements ChurchSource {
  final AppHttpClient _client;

  ChurchSourceImpl({required AppHttpClient client}) : _client = client;

  @override
  Future<Membership?> acceptChurchInvite({
    required String churchId,
    CancelToken? cancelToken,
  }) async {
    // TODO: implement acceptChurchInvite
    throw UnimplementedError();
  }

  @override
  Future<Church> addChurch({
    required ChurchEntity entity,
    CancelToken? cancelToken,
  }) {
    // TODO: implement addChurch
    throw UnimplementedError();
  }

  @override
  Future<bool> banMember({
    required ChurchEntity parameter,
    CancelToken? cancelToken,
  }) {
    // TODO: implement banMember
    throw UnimplementedError();
  }

  @override
  Future<bool> declineChurchInvite({
    required ChurchEntity parameter,
    CancelToken? cancelToken,
  }) {
    // TODO: implement declineChurchInvite
    throw UnimplementedError();
  }

  @override
  Future<void> deleteChurch({required String id, CancelToken? cancelToken}) {
    // TODO: implement deleteChurch
    throw UnimplementedError();
  }

  @override
  Future<Church?> getChurchById({
    required ChurchEntity parameter,
    CancelToken? cancelToken,
  }) async {
    final response = await _client.request(
      path: '${ApiPath.churches}/${parameter.id}',
      requestType: RequestType.get,
      cancelToken: cancelToken,
    );
    final data = response.data as Map<String, dynamic>;
    return Church.fromJson(data['church'] as Map<String, dynamic>);
  }

  @override
  Future<List<Church>> getChurches({
    ChurchEntity? parameter,
    CancelToken? cancelToken,
  }) async {
    final response = await _client.request(
      path: ApiPath.churches,
      requestType: RequestType.get,
      cancelToken: cancelToken,
      queryParams: parameter?.toMap(),
    );
    final data = response.data as Map<String, dynamic>;
    return (data['churches'] as List<dynamic>)
        .map((data) => Church.fromJson(data as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<Membership?> inviteMember({
    required ChurchEntity parameter,
    CancelToken? cancelToken,
  }) {
    // TODO: implement inviteMember
    throw UnimplementedError();
  }

  @override
  Future<bool> removeMemberFromChurch({
    required ChurchEntity parameter,
    CancelToken? cancelToken,
  }) {
    // TODO: implement removeMemberFromChurch
    throw UnimplementedError();
  }

  @override
  Future<List<Church>> searchChurches({
    ChurchEntity? parameter,
    CancelToken? cancelToken,
  }) {
    // TODO: implement searchChurches
    throw UnimplementedError();
  }

  @override
  Future<Church> updateChurch({
    required ChurchEntity parameter,
    CancelToken? cancelToken,
  }) {
    // TODO: implement updateChurch
    throw UnimplementedError();
  }

  @override
  Future<Membership?> updateMembersRoleInChurch({
    required ChurchEntity parameter,
    CancelToken? cancelToken,
  }) {
    // TODO: implement updateMembersRoleInChurch
    throw UnimplementedError();
  }

  @override
  Future<List<Location>> getLocations({
    ChurchEntity? parameter,
    CancelToken? cancelToken,
  }) async {
    _client.dio.options.baseUrl = 'https://maps.googleapis.com';

    // https://maps.googleapis.com/maps/api/place/autocomplete/json?input=lagos&key=AIzaSyBJsZVVNZfDNLlqLYcDzlU-3u8GaufGWKA&components=country:ng

    final response = await _client.request(
      path: '/maps/api/place/autocomplete/json',
      requestType: RequestType.get,
      cancelToken: cancelToken,
      queryParams: {
        'input': parameter?.location,
        'key': 'AIzaSyBJsZVVNZfDNLlqLYcDzlU-3u8GaufGWKA',
        'components': 'country:ng',
      },
    );
    final data = response.data as Map<String, dynamic>;
    return (data['predictions'] as List<dynamic>)
        .map((data) => Location.fromJson(data as Map<String, dynamic>))
        .toList();
  }
}
