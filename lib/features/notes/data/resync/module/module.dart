import 'dart:async';

import 'package:disciple/app/core/background/sync_manager.dart';
import 'package:disciple/app/core/manager/network_manager.dart';
import 'package:disciple/features/notes/data/resync/note_resync.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final syncManagerProvider = Provider<SyncManager>((ref) {
  final manager = SyncManager()..registerTask(NoteResyncTask(ref: ref));

  final networkManager = ref.read(networkManagerInstanceProvider);

  final StreamSubscription<NetworkStatus> subscription = networkManager
      .onStatusChanged
      .listen((status) {
        if (status == NetworkStatus.online) {
          unawaited(manager.runAllTasks());
        }
      });

  // Clean up when the provider is disposed
  ref.onDispose(() async {
    await subscription.cancel();
    manager.dispose();
  });

  return manager;
});
