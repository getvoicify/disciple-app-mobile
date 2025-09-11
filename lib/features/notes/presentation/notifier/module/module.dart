import 'package:dio/dio.dart';
import 'package:disciple/features/notes/data/model/note.dart';
import 'package:disciple/features/notes/domain/entity/note_entity.dart';
import 'package:disciple/features/notes/domain/usecase/module/module.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'module.g.dart';

@riverpod
Future<Note> generateOTP(Ref ref,
        {required NoteEntity parameter, CancelToken? cancelToken}) async =>
    await ref
        .read(addNoteUseCaseImpl)
        .execute(parameter: parameter, cancelToken: cancelToken);
