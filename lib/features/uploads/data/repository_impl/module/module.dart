import 'package:disciple/features/uploads/data/repository_impl/upload_repo_impl.dart';
import 'package:disciple/features/uploads/data/source_impl/module/module.dart';
import 'package:disciple/features/uploads/domain/repository/upload_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final uploadRepoModule = Provider<UploadRepository>(
  (ref) => UploadRepoImpl(source: ref.read(uploadSourceModule)),
);
