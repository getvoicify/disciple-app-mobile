import 'package:freezed_annotation/freezed_annotation.dart';

part 'membership.freezed.dart';
part 'membership.g.dart';

@freezed
abstract class Membership with _$Membership {
  const factory Membership({
    String? id,
    String? churchId,
    String? userId,
    String? role,
    String? status,
    DateTime? joinedAt,
    DateTime? updatedAt,
    String? invitedBy,
    DateTime? invitedAt,
  }) = _Membership;

  factory Membership.fromJson(Map<String, dynamic> json) =>
      _$MembershipFromJson(json);
}
