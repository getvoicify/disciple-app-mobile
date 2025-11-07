import 'dart:async';
import 'package:disciple/app/config/app_logger.dart';
import 'package:disciple/app/core/background/sync_manager.dart';
import 'package:disciple/app/core/manager/connectivity_manager.dart';
import 'package:disciple/app/utils/extension.dart';
import 'package:disciple/features/notes/data/resync/note_resync.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider that creates and manages the SyncManager instance
final syncManagerProvider = Provider<SyncManager>((ref) {
  final manager = SyncManager();
  final connectivityManager = ref.watch(connectivityManagerInstanceProvider);
  final logger = getLogger('SyncManagerProvider');

  // Register the note resync task
  final task = NoteResyncTask(ref: ref);
  if (!manager.registerTask(task)) {
    logger.w("NoteResyncTask registration failed - already registered");
  }

  // Listen to network changes
  connectivityManager.onStatusChanged.listen((status) {
    final isAuthenticated = ref.isloggedIn;
    logger.i("🔎 Network changed: $status | Logged in: $isAuthenticated");

    if (isAuthenticated && status == NetworkStatus.online) {
      logger.i("🚀 Triggering sync tasks");
      unawaited(
        manager.runAllTasks().catchError((error, stackTrace) {
          logger
            ..e("Error running sync tasks: $error")
            ..e("$stackTrace");
        }),
      );
    }
  });

  return manager;
});

// Helper provider to trigger sync manually if needed
final syncTriggerProvider = Provider<void>((ref) {
  // This watch makes the provider rebuild when dependencies change
  final _ = ref.watch(syncManagerProvider);
  final _ = ref.watch(connectivityManagerInstanceProvider);

  // The actual sync is triggered by the network listener above
  // This provider is just for triggering rebuilds when needed
});
