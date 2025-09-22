import 'dart:async';

import 'package:disciple/app/config/app_logger.dart';
import 'package:disciple/app/core/background/sync_manager.dart';
import 'package:disciple/app/core/manager/network_manager.dart';
import 'package:disciple/app/utils/extension.dart';
import 'package:disciple/features/notes/data/resync/note_resync.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final syncManagerProvider = Provider<SyncManager>((ref) {
  final manager = SyncManager()..registerTask(NoteResyncTask(ref: ref));
  final networkManager = ref.read(networkManagerInstanceProvider);

  final logger = getLogger('SyncManager');

  // 🔹 Listen to network changes
  networkManager.onStatusChanged.listen((status) {
    final bool isAuthenticated = ref.isloggedIn;

    logger.i("🔎 Network changed: $status: Logged in: $isAuthenticated 🌐");

    if (isAuthenticated && status == NetworkStatus.online) {
      unawaited(manager.runAllTasks());
    }
  });

  return manager;
});
