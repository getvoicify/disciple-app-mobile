import 'package:dio/dio.dart';
import 'package:disciple/features/community/data/model/church.dart';
import 'package:disciple/features/community/data/model/membership.dart';
import 'package:disciple/features/community/domain/entity/church_entity.dart';

abstract class ChurchRepository {
  Future<Church> addChurch({
    required ChurchEntity entity,
    CancelToken? cancelToken,
  });

  Future<List<Church>> getChurches({
    ChurchEntity? parameter,
    CancelToken? cancelToken,
  });

  Future<void> deleteChurch({required String id, CancelToken? cancelToken});

  Future<Church?> getChurchById({
    required ChurchEntity parameter,
    CancelToken? cancelToken,
  });

  Future<List<Church>> searchChurches({
    ChurchEntity? parameter,
    CancelToken? cancelToken,
  });

  Future<Church> updateChurch({
    required ChurchEntity parameter,
    CancelToken? cancelToken,
  });

  Future<Membership?> acceptChurchInvite({
    required String churchId,
    CancelToken? cancelToken,
  });

  Future<bool> banMember({
    required ChurchEntity parameter,
    CancelToken? cancelToken,
  });

  Future<bool> declineChurchInvite({
    required ChurchEntity parameter,
    CancelToken? cancelToken,
  });

  Future<Membership?> inviteMember({
    required ChurchEntity parameter,
    CancelToken? cancelToken,
  });

  Future<bool> removeMemberFromChurch({
    required ChurchEntity parameter,
    CancelToken? cancelToken,
  });

  Future<Membership?> updateMembersRoleInChurch({
    required ChurchEntity parameter,
    CancelToken? cancelToken,
  });
}
