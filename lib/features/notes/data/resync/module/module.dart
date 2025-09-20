import 'dart:async';

import 'package:disciple/app/core/background/sync_manager.dart';
import 'package:disciple/app/core/database/module/app_database_module.dart';
import 'package:disciple/app/core/manager/network_manager.dart';
import 'package:disciple/features/notes/data/mapper/module/module.dart';
import 'package:disciple/features/notes/data/resync/note_resync.dart';
import 'package:disciple/features/notes/data/source_impl/module/module.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final syncManagerProvider = Provider<SyncManager>((ref) {
  final manager = SyncManager()
    ..registerTask(
      NoteResyncTask(
        db: ref.watch(appDatabaseProvider),
        source: ref.watch(noteSourceModule),
        mapper: ref.watch(noteToCompanionMapperProvider),
      ),
    );

  final networkManager = ref.read(networkManagerInstanceProvider);

  final StreamSubscription<NetworkStatus> subscription = networkManager
      .onStatusChanged
      .listen((status) {
        switch (status) {
          case NetworkStatus.online:
            unawaited(manager.runAllTasks());
          case NetworkStatus.offline:
            break;
        }
      });

  // Clean up when the provider is disposed
  ref.onDispose(() async {
    await subscription.cancel();
    manager.dispose();
  });

  return manager;
});
