import 'package:freezed_annotation/freezed_annotation.dart';

part 'upload_state.freezed.dart';
part 'upload_state.g.dart';

@freezed
abstract class UploadState with _$UploadState {
  const factory UploadState({@Default(false) bool isUploading}) = _UploadState;
}
