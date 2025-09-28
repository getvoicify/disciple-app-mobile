import 'package:freezed_annotation/freezed_annotation.dart';

part 'church.freezed.dart';
part 'church.g.dart';

@freezed
abstract class Church with _$Church {
  const factory Church({
    String? id,
    String? slug,
    String? name,
    String? description,
    String? logoUrl,
    String? coverImageUrl,
    String? byline,
    String? missionStatement,
    Address? address,
    double? latitude,
    double? longitude,
    String? email,
    String? phoneNumber,
    String? websiteUrl,
    SocialLink? socialLinks,
    String? approvalStatus,
    String? visibility,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? version,
  }) = _Church;

  factory Church.fromJson(Map<String, dynamic> json) => _$ChurchFromJson(json);
}

@freezed
abstract class Address with _$Address {
  const factory Address({
    String? street,
    String? city,
    String? state,
    String? zipCode,
    String? country,
  }) = _Address;

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);
}

@freezed
abstract class SocialLink with _$SocialLink {
  const factory SocialLink({
    String? facebook,
    String? instagram,
    String? twitterX,
    String? youtube,
    String? tiktok,
    @Default([]) List<String> other,
  }) = _SocialLink;

  factory SocialLink.fromJson(Map<String, dynamic> json) =>
      _$SocialLinkFromJson(json);
}

extension ChurchExtension on Church {
  String get getAddress =>
      '${address?.city}, ${address?.state}, ${address?.country}';
}
