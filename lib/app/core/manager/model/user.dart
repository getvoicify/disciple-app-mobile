import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
abstract class User with _$User {
  const factory User({
    String? sub,
    @JsonKey(name: 'email_verified') bool? emailVerified,
    String? name,
    @JsonKey(name: 'preferred_username') String? preferredUsername,
    @JsonKey(name: 'given_name') String? givenName,
    @JsonKey(name: 'family_name') String? familyName,
    String? email,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

extension UserExtension on User {
  String get initial => givenName?.substring(0, 1) ?? '';
}
