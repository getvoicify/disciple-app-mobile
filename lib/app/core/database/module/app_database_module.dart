import 'package:disciple/app/core/database/app_database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_database_module.g.dart';

@riverpod
AppDatabase appDatabase(Ref ref) {
  final database = AppDatabase();

  // Dispose database when provider is disposed
  // ref.onDispose(() async => await database.close());

  return database;
}
