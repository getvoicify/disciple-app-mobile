import 'dart:io';
import 'package:disciple/app/config/app_logger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';

final notificationManagerProvider = Provider<NotificationManager>(
  (ref) => NotificationManager._instance,
);

class NotificationManager {
  NotificationManager._internal();
  static final NotificationManager _instance = NotificationManager._internal();
  factory NotificationManager() => _instance;

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  final logger = getLogger('NotificationManager');
  static const String _appIcon = 'mipmap/app_icon';

  Future<void> setNotificationSettings() async {
    final initialized = await _initialize();
    if (initialized) {
      await _ensureNotificationPermission();
      if (Platform.isAndroid) await _ensureExactAlarmPermission();
    }
  }

  /// Initialize only core settings — no permission prompts
  Future<bool> _initialize() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Africa/Lagos'));

    const androidSettings = AndroidInitializationSettings(_appIcon);
    const iosSettings = DarwinInitializationSettings();

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    final result = await _plugin.initialize(initSettings);
    logger.i('🔔 Notifications initialized: $result');
    return result ?? false;
  }

  /// Helper: check and request general notification permissions
  Future<bool> _ensureNotificationPermission() async {
    bool? granted;

    if (Platform.isIOS) {
      final ios = _plugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >();
      granted = await ios?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      logger.i('🍏 iOS Notification permission: $granted');
    } else if (Platform.isAndroid) {
      final android = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      granted = await android?.requestNotificationsPermission();
      logger.i('🤖 Android Notification permission: $granted');
    }

    return granted ?? false;
  }

  /// Helper: request exact alarm permission (Android 12+)
  Future<void> _ensureExactAlarmPermission() async {
    try {
      final info = await DeviceInfoPlugin().androidInfo;

      // Only relevant for Android 12+ (API 31+)
      if (info.version.sdkInt >= 31) {
        final androidPlugin = _plugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();

        // ✅ Check if exact alarms are already permitted
        final canScheduleExactAlarms =
            await androidPlugin?.requestExactAlarmsPermission() ?? false;

        if (canScheduleExactAlarms) {
          logger.i('✅ Exact alarm permission already granted');
          return;
        }

        // ❌ Not granted — open settings only once when needed
        const intent = AndroidIntent(
          action: 'android.settings.REQUEST_SCHEDULE_EXACT_ALARM',
          flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
        );
        await intent.launch();
        logger.i('⚙️ Requested exact alarm permission from settings');
      }
    } catch (e) {
      logger.w('⚠️ Could not verify/request exact alarm permission: $e');
    }
  }

  /// Shared notification details (avoids duplication)
  NotificationDetails get _defaultDetails => const NotificationDetails(
    android: AndroidNotificationDetails(
      'scheduled_notification_channel_id',
      'Scheduled Notifications',
      channelDescription:
          'Notifications that appear instantly or at a specific date/time',
      importance: Importance.max,
      priority: Priority.high,
      icon: _appIcon,
    ),
    iOS: DarwinNotificationDetails(),
  );

  /// Show an immediate notification
  Future<void> showNotification({
    required int id,
    required String title,
    String? body,
  }) async {
    if (!await _ensureNotificationPermission()) {
      logger.e('🚫 Notification permission not granted');
      return;
    }

    await _plugin.show(id, title, body, _defaultDetails);
    logger.i('📣 Notification shown: $title');
  }

  /// Schedule a notification for a specific time
  Future<void> scheduleNotificationAt({
    required int id,
    String title = 'Reminder',
    required String body,
    required DateTime scheduledAt,
  }) async {
    if (!await _ensureNotificationPermission()) {
      logger.e('🚫 Notification permission not granted');
      return;
    }

    final tzTime = tz.TZDateTime.from(scheduledAt, tz.local);
    if (tzTime.isBefore(tz.TZDateTime.now(tz.local))) {
      logger.w('⚠️ Attempted to schedule a notification in the past: $tzTime');
      return;
    }
    await _plugin.zonedSchedule(
      id,
      title,
      body,
      tzTime,
      _defaultDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );

    logger.i('⏰ Notification scheduled (exact) for $tzTime');
  }

  /// Cancel all scheduled and active notifications
  Future<void> cancelAll() async {
    await _plugin.cancelAll();
    await _plugin.cancelAllPendingNotifications();
    logger.i('🧹 All notifications canceled');
  }

  Future<void> cancel(int id) async {
    await _plugin.cancel(id);
    logger.i('🧹 Notification canceled');
  }
}
