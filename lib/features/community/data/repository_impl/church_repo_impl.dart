import 'package:dio/dio.dart';
import 'package:disciple/app/core/database/app_database.dart';
import 'package:disciple/app/core/database/module/app_database_module.dart';
import 'package:disciple/features/community/data/model/church.dart';
import 'package:disciple/features/community/data/model/gallery.dart';
import 'package:disciple/features/community/data/model/location.dart';
import 'package:disciple/features/community/data/model/membership.dart';
import 'package:disciple/features/community/data/model/post.dart';
import 'package:disciple/features/community/data/source_impl/module/module.dart';
import 'package:disciple/features/community/domain/entity/church_entity.dart';
import 'package:disciple/features/community/domain/entity/post_entity.dart';
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
  Future<Membership?> acceptChurchInvite({
    required String churchId,
    CancelToken? cancelToken,
  }) async => await _source.acceptChurchInvite(
    churchId: churchId,
    cancelToken: cancelToken,
  );

  @override
  Future<Church> addChurch({
    required ChurchEntity entity,
    CancelToken? cancelToken,
  }) async => await _source.addChurch(entity: entity, cancelToken: cancelToken);

  @override
  Future<bool> banMember({
    required ChurchEntity parameter,
    CancelToken? cancelToken,
  }) async =>
      await _source.banMember(parameter: parameter, cancelToken: cancelToken);

  @override
  Future<bool> declineChurchInvite({
    required ChurchEntity parameter,
    CancelToken? cancelToken,
  }) async => await _source.declineChurchInvite(
    parameter: parameter,
    cancelToken: cancelToken,
  );

  @override
  Future<void> deleteChurch({
    required String id,
    CancelToken? cancelToken,
  }) async => await _source.deleteChurch(id: id, cancelToken: cancelToken);

  @override
  Future<Church?> getChurchById({
    required ChurchEntity parameter,
    CancelToken? cancelToken,
  }) async => await _source.getChurchById(
    parameter: parameter,
    cancelToken: cancelToken,
  );

  @override
  Future<List<Church>> getChurches({
    ChurchEntity? parameter,
    CancelToken? cancelToken,
  }) async =>
      await _source.getChurches(parameter: parameter, cancelToken: cancelToken);

  @override
  Future<Membership?> inviteMember({
    required ChurchEntity parameter,
    CancelToken? cancelToken,
  }) async => await _source.inviteMember(
    parameter: parameter,
    cancelToken: cancelToken,
  );

  @override
  Future<bool> removeMemberFromChurch({
    required ChurchEntity parameter,
    CancelToken? cancelToken,
  }) async => await _source.removeMemberFromChurch(
    parameter: parameter,
    cancelToken: cancelToken,
  );

  @override
  Future<List<Church>> searchChurches({
    ChurchEntity? parameter,
    CancelToken? cancelToken,
  }) async => await _source.searchChurches(
    parameter: parameter,
    cancelToken: cancelToken,
  );

  @override
  Future<Church> updateChurch({
    required ChurchEntity parameter,
    CancelToken? cancelToken,
  }) async => await _source.updateChurch(
    parameter: parameter,
    cancelToken: cancelToken,
  );

  @override
  Future<Membership?> updateMembersRoleInChurch({
    required ChurchEntity parameter,
    CancelToken? cancelToken,
  }) async => await _source.updateMembersRoleInChurch(
    parameter: parameter,
    cancelToken: cancelToken,
  );

  @override
  Future<List<Location>> getLocations({
    ChurchEntity? parameter,
    CancelToken? cancelToken,
  }) async => await _source.getLocations(
    parameter: parameter,
    cancelToken: cancelToken,
  );

  @override
  Future<List<Post>> posts({
    PostEntity? entity,
    CancelToken? cancelToken,
  }) async => await _source.posts(entity: entity, cancelToken: cancelToken);

  @override
  Future<List<Gallery>> galleries({
    required String id,
    CancelToken? cancelToken,
  }) async => await _source.galleries(id: id, cancelToken: cancelToken);
}
