import 'package:freezed_annotation/freezed_annotation.dart';

part 'location.g.dart';
part 'location.freezed.dart';

@freezed
abstract class Location with _$Location {
  const factory Location({
    String? description,
    @JsonKey(name: 'place_id') String? placeId,
  }) = _Location;

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);
}
