import 'package:freezed_annotation/freezed_annotation.dart';

part 'upload.freezed.dart';
part 'upload.g.dart';

@freezed
abstract class Upload with _$Upload {
  const factory Upload({
    String? id,
    String? filename,
    String? originalFilename,
    String? mimeType,
    String? fileSize,
    String? uploadedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Upload;

  factory Upload.fromJson(Map<String, dynamic> json) => _$UploadFromJson(json);
}
