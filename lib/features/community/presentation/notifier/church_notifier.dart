import 'package:disciple/features/community/data/model/church.dart';
import 'package:disciple/features/community/data/model/location.dart';
import 'package:disciple/features/community/domain/entity/church_entity.dart';
import 'package:disciple/features/community/domain/usecase/module/module.dart';
import 'package:disciple/features/community/presentation/state/church_state.dart';
import 'package:disciple/widgets/notification/notification_tray.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'church_notifier.g.dart';

@Riverpod(keepAlive: true)
class ChurchNotifier extends _$ChurchNotifier {
  @override
  ChurchState build() => const ChurchState();

  final List<Church> _churches = [];
  List<Location> _locations = [];

  Future<void> addChurch({required ChurchEntity entity}) async {
    state = state.copyWith(isAddingChurch: true);
    try {
      await ref.read(addChurchUseCaseImpl).execute(parameter: entity);
    } catch (e) {
      triggerNotificationTray(e.toString(), error: true);
    } finally {
      state = state.copyWith(isAddingChurch: false);
    }
  }

  Future<void> getChurches({ChurchEntity? parameter}) async {
    state = state.copyWith(isLoadingChurches: true);
    try {
      final List<Church> churches = await ref
          .read(getChurchesUseCaseImpl)
          .execute(parameter: parameter);

      if (parameter?.page == 1) _churches.clear();

      _churches.addAll(churches);
    } catch (e) {
      triggerNotificationTray(e.toString(), error: true);
    } finally {
      state = state.copyWith(isLoadingChurches: false, churches: _churches);
    }
  }

  Future<void> getChurchById({required ChurchEntity parameter}) async {
    state = state.copyWith(isLoadingChurch: true);
    try {
      await ref.read(getChurchByIdUseCaseImpl).execute(parameter: parameter);
    } catch (e) {
      triggerNotificationTray(e.toString(), error: true);
    } finally {
      state = state.copyWith(isLoadingChurch: false);
    }
  }

  Future<void> updateChurch({required ChurchEntity entity}) async {
    state = state.copyWith(isUpdatingChurch: true);
    try {
      await ref.read(updateChurchUseCaseImpl).execute(parameter: entity);
    } catch (e) {
      triggerNotificationTray(e.toString(), error: true);
    } finally {
      state = state.copyWith(isUpdatingChurch: false);
    }
  }

  Future<void> deleteChurch({required String id}) async {
    state = state.copyWith(isDeletingChurch: true);
    try {
      await ref.read(deleteChurchUseCaseImpl).execute(parameter: id);
    } catch (e) {
      triggerNotificationTray(e.toString(), error: true);
    } finally {
      state = state.copyWith(isDeletingChurch: false);
    }
  }

  Future<void> acceptChurchInvite({required String churchId}) async {
    state = state.copyWith(isAcceptingChurchInvite: true);
    try {
      await ref
          .read(acceptChurchInviteUseCaseImpl)
          .execute(parameter: churchId);
    } catch (e) {
      triggerNotificationTray(e.toString(), error: true);
    } finally {
      state = state.copyWith(isAcceptingChurchInvite: false);
    }
  }

  Future<void> declineChurchInvite({required ChurchEntity parameter}) async {
    state = state.copyWith(isDecliningChurchInvite: true);
    try {
      await ref
          .read(declineChurchInviteUseCaseImpl)
          .execute(parameter: parameter);
    } catch (e) {
      triggerNotificationTray(e.toString(), error: true);
    } finally {
      state = state.copyWith(isDecliningChurchInvite: false);
    }
  }

  Future<void> inviteMember({required ChurchEntity parameter}) async {
    state = state.copyWith(isInvitingMember: true);
    try {
      await ref.read(inviteMemberUseCaseImpl).execute(parameter: parameter);
    } catch (e) {
      triggerNotificationTray(e.toString(), error: true);
    } finally {
      state = state.copyWith(isInvitingMember: false);
    }
  }

  Future<void> removeMemberFromChurch({required ChurchEntity parameter}) async {
    state = state.copyWith(isRemovingMemberFromChurch: true);
    try {
      await ref
          .read(removeMemberFromChurchUseCaseImpl)
          .execute(parameter: parameter);
    } catch (e) {
      triggerNotificationTray(e.toString(), error: true);
    } finally {
      state = state.copyWith(isRemovingMemberFromChurch: false);
    }
  }

  Future<void> updateMembersRoleInChurch({
    required ChurchEntity parameter,
  }) async {
    state = state.copyWith(isUpdatingMembersRoleInChurch: true);
    try {
      await ref
          .read(updateMembersRoleInChurchUseCaseImpl)
          .execute(parameter: parameter);
    } catch (e) {
      triggerNotificationTray(e.toString(), error: true);
    } finally {
      state = state.copyWith(isUpdatingMembersRoleInChurch: false);
    }
  }

  Future<void> banMember({required ChurchEntity parameter}) async {
    state = state.copyWith(isBanningMember: true);
    try {
      await ref.read(banMemberUseCaseImpl).execute(parameter: parameter);
    } catch (e) {
      triggerNotificationTray(e.toString(), error: true);
    } finally {
      state = state.copyWith(isBanningMember: false);
    }
  }

  Future<void> searchChurches({required ChurchEntity parameter}) async {
    state = state.copyWith(isSearchingChurches: true);
    try {
      final churches = await ref
          .read(searchChurchesUseCaseImpl)
          .execute(parameter: parameter);

      if (parameter.page == 1) _churches.clear();

      _churches.addAll(churches);
    } catch (_) {
    } finally {
      state = state.copyWith(isLoadingChurches: false, churches: _churches);
    }
  }

  Future<void> getLocations({required ChurchEntity parameter}) async {
    state = state.copyWith(isGettingLocations: true);
    try {
      _locations = await ref
          .read(getLocationsUseCaseImpl)
          .execute(parameter: parameter);
    } catch (_) {
    } finally {
      state = state.copyWith(isGettingLocations: false, locations: _locations);
    }
  }
}
