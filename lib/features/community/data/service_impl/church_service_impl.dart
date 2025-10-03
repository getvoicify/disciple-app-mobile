import 'package:dio/dio.dart';
import 'package:disciple/app/config/app_logger.dart';
import 'package:disciple/features/community/data/model/church.dart';
import 'package:disciple/features/community/data/model/location.dart';
import 'package:disciple/features/community/data/model/membership.dart';
import 'package:disciple/features/community/domain/entity/church_entity.dart';
import 'package:disciple/features/community/domain/repository/church_repository.dart';
import 'package:disciple/features/community/domain/service/church_service.dart';

class ChurchServiceImpl implements ChurchService {
  final _logger = getLogger('ChurchServiceImpl');

  final ChurchRepository _repository;

  ChurchServiceImpl({required ChurchRepository repository})
    : _repository = repository;

  @override
  Future<Membership?> acceptChurchInvite({
    required String churchId,
    CancelToken? cancelToken,
  }) async {
    Membership? membership;
    try {
      membership = await _repository.acceptChurchInvite(
        churchId: churchId,
        cancelToken: cancelToken,
      );
    } catch (e) {
      _logger.e('An error occurred while accepting church invite', error: e);
      rethrow;
    }
    return membership;
  }

  @override
  Future<Church> addChurch({
    required ChurchEntity entity,
    CancelToken? cancelToken,
  }) async {
    Church? church;
    try {
      church = await _repository.addChurch(
        entity: entity,
        cancelToken: cancelToken,
      );
    } catch (e) {
      _logger.e('An error occurred while adding church', error: e);
      rethrow;
    }
    return church;
  }

  @override
  Future<bool> banMember({
    required ChurchEntity parameter,
    CancelToken? cancelToken,
  }) async {
    bool result = false;
    try {
      result = await _repository.banMember(
        parameter: parameter,
        cancelToken: cancelToken,
      );
    } catch (e) {
      _logger.e('An error occurred while banning member', error: e);
      rethrow;
    }
    return result;
  }

  @override
  Future<bool> declineChurchInvite({
    required ChurchEntity parameter,
    CancelToken? cancelToken,
  }) async {
    bool result = false;
    try {
      result = await _repository.declineChurchInvite(
        parameter: parameter,
        cancelToken: cancelToken,
      );
    } catch (e) {
      _logger.e('An error occurred while declining church invite', error: e);
      rethrow;
    }
    return result;
  }

  @override
  Future<void> deleteChurch({
    required String id,
    CancelToken? cancelToken,
  }) async {
    try {
      await _repository.deleteChurch(id: id, cancelToken: cancelToken);
    } catch (e) {
      _logger.e('An error occurred while deleting church', error: e);
      rethrow;
    }
  }

  @override
  Future<Church?> getChurchById({
    required ChurchEntity parameter,
    CancelToken? cancelToken,
  }) async {
    Church? church;
    try {
      church = await _repository.getChurchById(
        parameter: parameter,
        cancelToken: cancelToken,
      );
    } catch (e) {
      _logger.e('An error occurred while getting church by id', error: e);
      rethrow;
    }
    return church;
  }

  @override
  Future<List<Church>> getChurches({
    ChurchEntity? parameter,
    CancelToken? cancelToken,
  }) async {
    List<Church> churches = [];
    try {
      churches = await _repository.getChurches(
        parameter: parameter,
        cancelToken: cancelToken,
      );
    } catch (e) {
      _logger.e('An error occurred while getting churches', error: e);
      rethrow;
    }
    return churches;
  }

  @override
  Future<Membership?> inviteMember({
    required ChurchEntity parameter,
    CancelToken? cancelToken,
  }) async {
    Membership? membership;
    try {
      membership = await _repository.inviteMember(
        parameter: parameter,
        cancelToken: cancelToken,
      );
    } catch (e) {
      _logger.e('An error occurred while inviting member', error: e);
      rethrow;
    }
    return membership;
  }

  @override
  Future<bool> removeMemberFromChurch({
    required ChurchEntity parameter,
    CancelToken? cancelToken,
  }) async {
    bool result = false;
    try {
      result = await _repository.removeMemberFromChurch(
        parameter: parameter,
        cancelToken: cancelToken,
      );
    } catch (e) {
      _logger.e(
        'An error occurred while removing member from church',
        error: e,
      );
      rethrow;
    }
    return result;
  }

  @override
  Future<List<Church>> searchChurches({
    ChurchEntity? parameter,
    CancelToken? cancelToken,
  }) async {
    List<Church> churches = [];
    try {
      churches = await _repository.searchChurches(
        parameter: parameter,
        cancelToken: cancelToken,
      );
    } catch (e) {
      _logger.e('An error occurred while searching churches', error: e);
      rethrow;
    }
    return churches;
  }

  @override
  Future<Church> updateChurch({
    required ChurchEntity parameter,
    CancelToken? cancelToken,
  }) async {
    Church? church;
    try {
      church = await _repository.updateChurch(
        parameter: parameter,
        cancelToken: cancelToken,
      );
    } catch (e) {
      _logger.e('An error occurred while updating church', error: e);
      rethrow;
    }
    return church;
  }

  @override
  Future<Membership?> updateMembersRoleInChurch({
    required ChurchEntity parameter,
    CancelToken? cancelToken,
  }) async {
    Membership? membership;
    try {
      membership = await _repository.updateMembersRoleInChurch(
        parameter: parameter,
        cancelToken: cancelToken,
      );
    } catch (e) {
      _logger.e(
        'An error occurred while updating members role in church',
        error: e,
      );
      rethrow;
    }
    return membership;
  }

  @override
  Future<List<Location>> getLocations({
    ChurchEntity? parameter,
    CancelToken? cancelToken,
  }) async {
    List<Location> locations = [];
    try {
      locations = await _repository.getLocations(
        parameter: parameter,
        cancelToken: cancelToken,
      );
    } catch (e) {
      _logger.e('An error occurred while getting locations', error: e);
      rethrow;
    }
    return locations;
  }
}
