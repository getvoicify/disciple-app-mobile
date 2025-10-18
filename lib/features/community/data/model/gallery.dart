import 'package:freezed_annotation/freezed_annotation.dart';

part 'gallery.freezed.dart';
part 'gallery.g.dart';

@freezed
abstract class Gallery with _$Gallery {
  const factory Gallery({String? id}) = _Gallery;

  factory Gallery.fromJson(Map<String, dynamic> json) =>
      _$GalleryFromJson(json);
}
