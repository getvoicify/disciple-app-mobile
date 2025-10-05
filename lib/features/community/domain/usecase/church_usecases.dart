import 'package:dio/dio.dart' show CancelToken;
import 'package:disciple/app/core/usecase/disciple_usecase.dart';
import 'package:disciple/features/community/data/model/church.dart';
import 'package:disciple/features/community/data/model/location.dart';
import 'package:disciple/features/community/data/model/membership.dart';
import 'package:disciple/features/community/data/model/post.dart';
import 'package:disciple/features/community/domain/entity/church_entity.dart';
import 'package:disciple/features/community/domain/entity/post_entity.dart';
import 'package:disciple/features/community/domain/service/church_service.dart';

class AddChurchUseCaseImpl
    implements DiscipleUseCaseWithRequiredParam<ChurchEntity, Church> {
  final ChurchService _service;

  AddChurchUseCaseImpl({required ChurchService service}) : _service = service;

  @override
  Future<Church> execute({
    required ChurchEntity parameter,
    CancelToken? cancelToken,
  }) async => await _service.addChurch(entity: parameter);
}

class GetChurchesUseCaseImpl
    implements DiscipleUseCaseWithOptionalParam<ChurchEntity, List<Church>> {
  final ChurchService _service;

  GetChurchesUseCaseImpl({required ChurchService service}) : _service = service;

  @override
  Future<List<Church>> execute({
    ChurchEntity? parameter,
    CancelToken? cancelToken,
  }) async => await _service.getChurches(parameter: parameter);
}

class GetChurchByIdUseCaseImpl
    implements DiscipleUseCaseWithRequiredParam<ChurchEntity, Church?> {
  final ChurchService _service;

  GetChurchByIdUseCaseImpl({required ChurchService service})
    : _service = service;

  @override
  Future<Church?> execute({
    required ChurchEntity parameter,
    CancelToken? cancelToken,
  }) async => await _service.getChurchById(parameter: parameter);
}

class SearchChurchesUseCaseImpl
    implements DiscipleUseCaseWithRequiredParam<ChurchEntity, List<Church>> {
  final ChurchService _service;

  SearchChurchesUseCaseImpl({required ChurchService service})
    : _service = service;

  @override
  Future<List<Church>> execute({
    required ChurchEntity parameter,
    CancelToken? cancelToken,
  }) async => await _service.searchChurches(parameter: parameter);
}

class UpdateChurchUseCaseImpl
    implements DiscipleUseCaseWithRequiredParam<ChurchEntity, Church> {
  final ChurchService _service;

  UpdateChurchUseCaseImpl({required ChurchService service})
    : _service = service;

  @override
  Future<Church> execute({
    required ChurchEntity parameter,
    CancelToken? cancelToken,
  }) async => await _service.updateChurch(parameter: parameter);
}

class AcceptChurchInviteUseCaseImpl
    implements DiscipleUseCaseWithRequiredParam<String, Membership?> {
  final ChurchService _service;

  AcceptChurchInviteUseCaseImpl({required ChurchService service})
    : _service = service;

  @override
  Future<Membership?> execute({
    required String parameter,
    CancelToken? cancelToken,
  }) async => await _service.acceptChurchInvite(churchId: parameter);
}

class DeclineChurchInviteUseCaseImpl
    implements DiscipleUseCaseWithRequiredParam<ChurchEntity, bool> {
  final ChurchService _service;

  DeclineChurchInviteUseCaseImpl({required ChurchService service})
    : _service = service;

  @override
  Future<bool> execute({
    required ChurchEntity parameter,
    CancelToken? cancelToken,
  }) async => await _service.declineChurchInvite(parameter: parameter);
}

class InviteMemberUseCaseImpl
    implements DiscipleUseCaseWithRequiredParam<ChurchEntity, Membership?> {
  final ChurchService _service;

  InviteMemberUseCaseImpl({required ChurchService service})
    : _service = service;

  @override
  Future<Membership?> execute({
    required ChurchEntity parameter,
    CancelToken? cancelToken,
  }) async => await _service.inviteMember(parameter: parameter);
}

class BanMemberUseCaseImpl
    implements DiscipleUseCaseWithRequiredParam<ChurchEntity, bool> {
  final ChurchService _service;

  BanMemberUseCaseImpl({required ChurchService service}) : _service = service;

  @override
  Future<bool> execute({
    required ChurchEntity parameter,
    CancelToken? cancelToken,
  }) async => await _service.banMember(parameter: parameter);
}

class RemoveMemberFromChurchUseCaseImpl
    implements DiscipleUseCaseWithRequiredParam<ChurchEntity, bool> {
  final ChurchService _service;

  RemoveMemberFromChurchUseCaseImpl({required ChurchService service})
    : _service = service;

  @override
  Future<bool> execute({
    required ChurchEntity parameter,
    CancelToken? cancelToken,
  }) async => await _service.removeMemberFromChurch(parameter: parameter);
}

class UpdateMembersRoleInChurchUseCaseImpl
    implements DiscipleUseCaseWithRequiredParam<ChurchEntity, Membership?> {
  final ChurchService _service;

  UpdateMembersRoleInChurchUseCaseImpl({required ChurchService service})
    : _service = service;

  @override
  Future<Membership?> execute({
    required ChurchEntity parameter,
    CancelToken? cancelToken,
  }) async => await _service.updateMembersRoleInChurch(parameter: parameter);
}

class DeleteChurchUseCaseImpl
    implements DiscipleUseCaseWithRequiredParam<String, void> {
  final ChurchService _service;

  DeleteChurchUseCaseImpl({required ChurchService service})
    : _service = service;

  @override
  Future<void> execute({
    required String parameter,
    CancelToken? cancelToken,
  }) async => await _service.deleteChurch(id: parameter);
}

class GetLocationsUseCaseImpl
    implements DiscipleUseCaseWithRequiredParam<ChurchEntity, List<Location>> {
  final ChurchService _service;

  GetLocationsUseCaseImpl({required ChurchService service})
    : _service = service;

  @override
  Future<List<Location>> execute({
    required ChurchEntity parameter,
    CancelToken? cancelToken,
  }) async => await _service.getLocations(parameter: parameter);
}

class GetPostsUseCaseImpl
    implements DiscipleUseCaseWithOptionalParam<PostEntity, List<Post>> {
  final ChurchService _service;

  GetPostsUseCaseImpl({required ChurchService service}) : _service = service;

  @override
  Future<List<Post>> execute({
    PostEntity? parameter,
    CancelToken? cancelToken,
  }) async => await _service.posts(entity: parameter);
}
