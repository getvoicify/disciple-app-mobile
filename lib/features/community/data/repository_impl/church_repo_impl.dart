import 'package:disciple/app/core/database/app_database.dart';
import 'package:disciple/app/core/database/module/app_database_module.dart';
import 'package:disciple/features/community/data/model/church.dart';
import 'package:disciple/features/community/data/model/membership.dart';
import 'package:disciple/features/community/data/source_impl/module/module.dart';
import 'package:disciple/features/community/domain/entity/church_entity.dart';
import 'package:disciple/features/community/domain/repository/church_repository.dart';
import 'package:disciple/features/community/domain/source/church_source.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChurchRepoImpl implements ChurchRepository {
  final ChurchSource _source;
  final AppDatabase _database;

  final Ref ref;

  ChurchRepoImpl({required this.ref})
    : _source = ref.watch(churchSourceModule),
      _database = ref.watch(appDatabaseProvider);

  @override
  Future<Membership?> acceptChurchInvite({required String churchId}) async =>
      await _source.acceptChurchInvite(churchId: churchId);

  @override
  Future<Church> addChurch({required ChurchEntity entity}) async =>
      await _source.addChurch(entity: entity);

  @override
  Future<bool> banMember({required ChurchEntity parameter}) async =>
      await _source.banMember(parameter: parameter);

  @override
  Future<bool> declineChurchInvite({required ChurchEntity parameter}) async =>
      await _source.declineChurchInvite(parameter: parameter);

  @override
  Future<void> deleteChurch({required String id}) async =>
      await _source.deleteChurch(id: id);

  @override
  Future<Church?> getChurchById({required ChurchEntity parameter}) async =>
      await _source.getChurchById(parameter: parameter);

  @override
  Future<List<Church>> getChurches({ChurchEntity? parameter}) async =>
      await _source.getChurches(parameter: parameter);

  @override
  Future<Membership?> inviteMember({required ChurchEntity parameter}) async =>
      await _source.inviteMember(parameter: parameter);

  @override
  Future<bool> removeMemberFromChurch({
    required ChurchEntity parameter,
  }) async => await _source.removeMemberFromChurch(parameter: parameter);

  @override
  Future<List<Church>> searchChurches({ChurchEntity? parameter}) async =>
      await _source.searchChurches(parameter: parameter);

  @override
  Future<Church> updateChurch({required ChurchEntity parameter}) async =>
      await _source.updateChurch(parameter: parameter);

  @override
  Future<Membership?> updateMembersRoleInChurch({
    required ChurchEntity parameter,
  }) async => await _source.updateMembersRoleInChurch(parameter: parameter);
}
