import 'package:disciple/app/core/database/app_database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_database_module.g.dart';

@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  final db = AppDatabase();
  // clean shutdown when ProviderScope is destroyed
  ref.onDispose(() => db.close());
  return db;
}
