import 'package:disciple/features/community/data/model/church.dart';
import 'package:disciple/features/community/data/model/membership.dart';
import 'package:disciple/features/community/domain/entity/church_entity.dart';

abstract class ChurchContract {
  Future<Church> addChurch({required ChurchEntity entity});
  Future<List<Church>> getChurches({ChurchEntity? parameter});
  Future<void> deleteChurch({required String id});
  Future<Church?> getChurchById({required ChurchEntity parameter});
  Future<List<Church>> searchChurches({ChurchEntity? parameter});
  Future<Church> updateChurch({required ChurchEntity parameter});
  Future<Membership?> acceptChurchInvite({required String churchId});
  Future<bool> banMember({required ChurchEntity parameter});
  Future<bool> declineChurchInvite({required ChurchEntity parameter});
  Future<Membership?> inviteMember({required ChurchEntity parameter});
  Future<bool> removeMemberFromChurch({required ChurchEntity parameter});
  Future<Membership?> updateMembersRoleInChurch({
    required ChurchEntity parameter,
  });
}
