import 'package:disciple/app/core/http/api_path.dart';
import 'package:disciple/app/core/http/app_http_client.dart';
import 'package:disciple/features/community/data/model/church.dart';
import 'package:disciple/features/community/data/model/membership.dart';
import 'package:disciple/features/community/domain/entity/church_entity.dart';
import 'package:disciple/features/community/domain/source/church_source.dart';

class ChurchSourceImpl implements ChurchSource {
  final AppHttpClient _client;

  ChurchSourceImpl({required AppHttpClient client}) : _client = client;

  @override
  Future<Membership?> acceptChurchInvite({required String churchId}) async {
    // TODO: implement acceptChurchInvite
    throw UnimplementedError();
  }

  @override
  Future<Church> addChurch({required ChurchEntity entity}) {
    // TODO: implement addChurch
    throw UnimplementedError();
  }

  @override
  Future<bool> banMember({required ChurchEntity parameter}) {
    // TODO: implement banMember
    throw UnimplementedError();
  }

  @override
  Future<bool> declineChurchInvite({required ChurchEntity parameter}) {
    // TODO: implement declineChurchInvite
    throw UnimplementedError();
  }

  @override
  Future<void> deleteChurch({required String id}) {
    // TODO: implement deleteChurch
    throw UnimplementedError();
  }

  @override
  Future<Church?> getChurchById({required ChurchEntity parameter}) async {
    final response = await _client.request(
      path: '${ApiPath.churches}/${parameter.id}',
      requestType: RequestType.get,
    );
    final data = response.data as Map<String, dynamic>;
    return Church.fromJson(data['church'] as Map<String, dynamic>);
  }

  @override
  Future<List<Church>> getChurches({ChurchEntity? parameter}) async {
    final response = await _client.request(
      path: ApiPath.churches,
      requestType: RequestType.get,
      cancelToken: parameter?.cancelToken,
      queryParams: parameter?.toMap(),
    );
    final data = response.data as Map<String, dynamic>;
    return (data['churches'] as List<dynamic>)
        .map((data) => Church.fromJson(data as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<Membership?> inviteMember({required ChurchEntity parameter}) {
    // TODO: implement inviteMember
    throw UnimplementedError();
  }

  @override
  Future<bool> removeMemberFromChurch({required ChurchEntity parameter}) {
    // TODO: implement removeMemberFromChurch
    throw UnimplementedError();
  }

  @override
  Future<List<Church>> searchChurches({ChurchEntity? parameter}) {
    // TODO: implement searchChurches
    throw UnimplementedError();
  }

  @override
  Future<Church> updateChurch({required ChurchEntity parameter}) {
    // TODO: implement updateChurch
    throw UnimplementedError();
  }

  @override
  Future<Membership?> updateMembersRoleInChurch({
    required ChurchEntity parameter,
  }) {
    // TODO: implement updateMembersRoleInChurch
    throw UnimplementedError();
  }
}
