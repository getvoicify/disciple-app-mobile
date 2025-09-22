import 'dart:async';
import 'package:disciple/app/config/app_logger.dart';

abstract class ResyncTask {
  String get taskId; // Unique identifier for each task
  Future<void> run();
}

class SyncManager {
  final _logger = getLogger('SyncManager');
  final Map<String, ResyncTask> _tasks = {}; // Using Map to prevent duplicates
  bool _isRunning = false;
  Completer<void>? _currentRun;

  SyncManager();

  /// Register a new sync task if it doesn't already exist
  /// Returns true if the task was registered, false if it already exists
  bool registerTask(ResyncTask task) {
    if (_tasks.containsKey(task.taskId)) {
      _logger.w("⚠️ Task with ID '${task.taskId}' is already registered");
      return false;
    }

    _tasks[task.taskId] = task;
    _logger.i("✅ Registered task: ${task.runtimeType} (ID: ${task.taskId})");
    return true;
  }

  /// Unregister a task by its ID
  bool unregisterTask(String taskId) {
    if (_tasks.remove(taskId) != null) {
      _logger.i("🗑️ Unregistered task: $taskId");
      return true;
    }
    return false;
  }

  /// Run all registered tasks safely
  /// Returns a Future that completes when all tasks are done
  Future<void> runAllTasks() async {
    if (_isRunning) {
      _logger.w("⏳ A sync operation is already in progress");
      return _currentRun?.future ?? Future.value();
    }

    if (_tasks.isEmpty) {
      _logger.w("⚠️ No tasks registered, skipping sync");
      return;
    }

    _isRunning = true;
    final completer = Completer<void>();
    _currentRun = completer;

    try {
      _logger.i("🔄 Starting sync of ${_tasks.length} tasks");

      // Create a copy of tasks to avoid concurrent modification
      final tasksToRun = Map<String, ResyncTask>.from(_tasks);

      for (final entry in tasksToRun.entries) {
        final taskId = entry.key;
        final task = entry.value;

        try {
          _logger.i("🚀 Running task: ${task.runtimeType} (ID: $taskId)");
          await task.run();
          _logger.i("✅ Completed task: ${task.runtimeType} (ID: $taskId)");
        } catch (e, st) {
          _logger
            ..e('❌ Task failed: ${task.runtimeType} (ID: $taskId)')
            ..e('Error: $e')
            ..e('Stacktrace: $st');
        }
      }

      _logger.i("✨ All tasks completed");
      completer.complete();
    } catch (e, st) {
      _logger
        ..e('❌ Critical error in sync operation')
        ..e('Error: $e')
        ..e('Stacktrace: $st');
      completer.completeError(e, st);
    } finally {
      _isRunning = false;
      _currentRun = null;
    }
  }

  /// Get a list of all registered task IDs
  List<String> get registeredTaskIds => _tasks.keys.toList();

  /// Check if a specific task is registered
  bool isTaskRegistered(String taskId) => _tasks.containsKey(taskId);

  /// Get the number of registered tasks
  int get taskCount => _tasks.length;

  /// Clear all registered tasks
  void clearTasks() {
    _logger.w("🧹 Clearing all ${_tasks.length} tasks");
    _tasks.clear();
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
