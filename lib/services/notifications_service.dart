import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

/// Real local daily-reminder notifications for the "Daily Reminder" toggle
/// on the Edit Profile screen — a genuinely scheduled OS notification, not
/// a decorative switch. No backend involved: this is entirely on-device via
/// flutter_local_notifications, fired daily at a fixed 9:00 AM local time.
class NotificationsService {
  NotificationsService._();

  static const _prefsKey = 'nyaya_daily_reminder_enabled';
  static const _reminderId = 1001;

  static final _plugin = FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;
    tz_data.initializeTimeZones();
    try {
      final timezoneInfo = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timezoneInfo.identifier));
    } catch (_) {
      // Falls back to UTC if the platform timezone lookup fails — the
      // reminder still fires daily, just possibly not at local 9 AM.
    }

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);
    await _plugin.initialize(initSettings);
    _initialized = true;
  }

  static Future<bool> isEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_prefsKey) ?? false;
  }

  /// Requests notification permission (Android 13+) and, if granted,
  /// schedules the real daily reminder. Returns whether it ended up
  /// enabled, so the caller's toggle reflects what actually happened.
  static Future<bool> setEnabled(bool enabled) async {
    await init();
    final prefs = await SharedPreferences.getInstance();

    if (!enabled) {
      await _plugin.cancel(_reminderId);
      await prefs.setBool(_prefsKey, false);
      return false;
    }

    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    final granted = await androidPlugin?.requestNotificationsPermission() ?? true;
    if (granted != true) {
      await prefs.setBool(_prefsKey, false);
      return false;
    }

    await _scheduleDaily9Am();
    await prefs.setBool(_prefsKey, true);
    return true;
  }

  static Future<void> _scheduleDaily9Am() async {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, 9);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    await _plugin.zonedSchedule(
      _reminderId,
      'NYAYA',
      'Time for your daily legal learning — keep your streak going.',
      scheduled,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_reminder',
          'Daily Learning Reminder',
          channelDescription: 'A daily reminder to continue learning on NYAYA.',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }
}
