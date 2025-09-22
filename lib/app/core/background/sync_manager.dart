import 'dart:async';
import 'package:disciple/app/config/app_logger.dart';

abstract class ResyncTask {
  Future<void> run();
}

class SyncManager {
  final _logger = getLogger('SyncManager');
  final List<ResyncTask> _tasks = [];

  SyncManager();

  /// Register a new sync task (usually done at startup)
  void registerTask(ResyncTask task) {
    _tasks.add(task);
    _logger.i("✅ Registered task: ${task.runtimeType}");
  }

  /// Run all registered tasks safely
  Future<void> runAllTasks() async {
    if (_tasks.isEmpty) {
      _logger.w("⚠️ No tasks registered, skipping sync");
      return;
    }

    // Snapshot to prevent concurrent modification during iteration
    final tasksSnapshot = List<ResyncTask>.from(_tasks);

    for (final task in tasksSnapshot) {
      try {
        _logger.i("🚀 Running task: ${task.runtimeType}");
        await task.run();
        _logger.i("✅ Completed task: ${task.runtimeType}");
      } catch (e, st) {
        _logger
          ..e('❌ Sync task failed: $e')
          ..e('Stacktrace: $st');
      }
    }
  }

  /// Dispose manager and clear all tasks
  void dispose() {
    if (_tasks.isNotEmpty) {
      _logger.w("🧹 Disposing SyncManager → clearing ${_tasks.length} tasks");
      _tasks.clear();
    } else {
      _logger.w("🧹 Disposing SyncManager → no tasks to clear");
    }
  }
}
