import 'package:disciple/app/config/app_logger.dart';
import 'package:disciple/features/community/data/model/church.dart';
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
  Future<Membership?> acceptChurchInvite({required String churchId}) async {
    Membership? membership;
    try {
      membership = await _repository.acceptChurchInvite(churchId: churchId);
    } catch (e) {
      _logger.e('An error occurred while accepting church invite', error: e);
      rethrow;
    }
    return membership;
  }

  @override
  Future<Church> addChurch({required ChurchEntity entity}) async {
    Church? church;
    try {
      church = await _repository.addChurch(entity: entity);
    } catch (e) {
      _logger.e('An error occurred while adding church', error: e);
      rethrow;
    }
    return church;
  }

  @override
  Future<bool> banMember({required ChurchEntity parameter}) async {
    bool result = false;
    try {
      result = await _repository.banMember(parameter: parameter);
    } catch (e) {
      _logger.e('An error occurred while banning member', error: e);
      rethrow;
    }
    return result;
  }

  @override
  Future<bool> declineChurchInvite({required ChurchEntity parameter}) async {
    bool result = false;
    try {
      result = await _repository.declineChurchInvite(parameter: parameter);
    } catch (e) {
      _logger.e('An error occurred while declining church invite', error: e);
      rethrow;
    }
    return result;
  }

  @override
  Future<void> deleteChurch({required String id}) async {
    try {
      await _repository.deleteChurch(id: id);
    } catch (e) {
      _logger.e('An error occurred while deleting church', error: e);
      rethrow;
    }
  }

  @override
  Future<Church?> getChurchById({required ChurchEntity parameter}) async {
    Church? church;
    try {
      church = await _repository.getChurchById(parameter: parameter);
    } catch (e) {
      _logger.e('An error occurred while getting church by id', error: e);
      rethrow;
    }
    return church;
  }

  @override
  Future<List<Church>> getChurches({ChurchEntity? parameter}) async {
    List<Church> churches = [];
    try {
      churches = await _repository.getChurches(parameter: parameter);
    } catch (e) {
      _logger.e('An error occurred while getting churches', error: e);
      rethrow;
    }
    return churches;
  }

  @override
  Future<Membership?> inviteMember({required ChurchEntity parameter}) async {
    Membership? membership;
    try {
      membership = await _repository.inviteMember(parameter: parameter);
    } catch (e) {
      _logger.e('An error occurred while inviting member', error: e);
      rethrow;
    }
    return membership;
  }

  @override
  Future<bool> removeMemberFromChurch({required ChurchEntity parameter}) async {
    bool result = false;
    try {
      result = await _repository.removeMemberFromChurch(parameter: parameter);
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
  Future<List<Church>> searchChurches({ChurchEntity? parameter}) async {
    List<Church> churches = [];
    try {
      churches = await _repository.searchChurches(parameter: parameter);
    } catch (e) {
      _logger.e('An error occurred while searching churches', error: e);
      rethrow;
    }
    return churches;
  }

  @override
  Future<Church> updateChurch({required ChurchEntity parameter}) async {
    Church? church;
    try {
      church = await _repository.updateChurch(parameter: parameter);
    } catch (e) {
      _logger.e('An error occurred while updating church', error: e);
      rethrow;
    }
    return church;
  }

  @override
  Future<Membership?> updateMembersRoleInChurch({
    required ChurchEntity parameter,
  }) async {
    Membership? membership;
    try {
      membership = await _repository.updateMembersRoleInChurch(
        parameter: parameter,
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
}
