import 'package:disciple/app/core/database/app_database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_database_module.g.dart';

<<<<<<< HEAD
@riverpod
AppDatabase appDatabase(Ref ref) {
  final database = AppDatabase();

  // Dispose database when provider is disposed
  // ref.onDispose(() async => await database.close());

  return database;
=======
@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  final db = AppDatabase();
  // clean shutdown when ProviderScope is destroyed
  ref.onDispose(() => db.close());
  return db;
>>>>>>> b05cc9c14293b73379b299e1f81efe7ebc10826b
}
