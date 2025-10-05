import 'package:disciple/features/community/data/model/church.dart';
import 'package:disciple/features/community/data/model/location.dart';
import 'package:disciple/features/community/data/model/post.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'church_state.freezed.dart';
part 'church_state.g.dart';

@freezed
abstract class ChurchState with _$ChurchState {
  const factory ChurchState({
    @Default(false) bool isAddingChurch,
    @Default(false) bool isLoadingChurch,
    @Default(false) bool isDeletingChurch,
    @Default(false) bool isUpdatingChurch,
    @JsonKey(includeFromJson: false, includeToJson: false) Church? church,
    @Default([]) List<Church> churches,
    @Default(false) bool isLoadingChurches,
    @Default(false) bool isSearchingChurches,
    @Default(false) bool isAcceptingChurchInvite,
    @Default(false) bool isDecliningChurchInvite,
    @Default(false) bool isInvitingMember,
    @Default(false) bool isRemovingMemberFromChurch,
    @Default(false) bool isUpdatingMembersRoleInChurch,
    @Default(false) bool isBanningMember,
    @Default(false) bool isGettingLocations,
    @Default([]) List<Location> locations,
    @Default(false) bool isGettingPosts,
    @Default([]) List<Post> posts,
  }) = _ChurchState;
}
