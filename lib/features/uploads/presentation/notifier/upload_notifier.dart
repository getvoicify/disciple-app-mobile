import 'package:disciple/app/core/http/api_path.dart';
import 'package:disciple/features/uploads/data/model/upload.dart';
import 'package:disciple/features/uploads/domain/usecase/module/module.dart';
import 'package:disciple/features/uploads/presentation/state/upload_state.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'upload_notifier.g.dart';

@Riverpod(keepAlive: true)
class UploadNotifier extends _$UploadNotifier {
  @override
  UploadState build() => const UploadState();

  List<String?> _images = [];

  Future<List<String>> uploadAll({required List<XFile> files}) async {
    state = state.copyWith(isUploading: true);
    // Run uploads in parallel with error isolation
    try {
      _images = await Future.wait(
        files.map((file) async {
          final Upload? result = await ref
              .read(uploadMediaUseCaseImpl)
              .execute(parameter: file);
          return ApiPath.imageUrl(result?.id ?? '');
        }),
      );
    } catch (_) {
    } finally {
      state = state.copyWith(isUploading: false);
    }
    // Keep only successful IDs
    return _images.whereType<String>().toList();
  }
}
