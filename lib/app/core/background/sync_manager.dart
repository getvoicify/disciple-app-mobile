import 'dart:async';

import 'package:disciple/app/config/app_logger.dart';

abstract class ResyncTask {
  Future<void> run();
}

class SyncManager {
  final _logger = getLogger('SyncManager');
  final List<ResyncTask> _tasks = [];

  SyncManager();

  void registerTask(ResyncTask task) {
    _tasks.add(task);
  }

  Future<void> runAllTasks() async {
    for (final task in _tasks) {
      try {
        await task.run();
      } catch (e, st) {
        // Log or retry later
        _logger
          ..e('Sync task failed: $e')
          ..e('Sync task failed: $st');
      }
    }
  }

  void dispose() {
    _tasks.clear();
  }
}
