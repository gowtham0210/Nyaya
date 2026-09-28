import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

/// Schedules the daily practice reminder (ADR 0004). Tests pass a fake.
abstract class ReminderScheduler {
  /// Asks for notification permission; true when granted.
  Future<bool> requestPermission();

  /// Replaces any reminder with one every day at [hour]:[minute] local time.
  Future<void> scheduleDaily({
    required int hour,
    required int minute,
    required String title,
    required String body,
    required String channelName,
  });

  Future<void> cancel();
}

/// [ReminderScheduler] on `flutter_local_notifications`.
class LocalNotificationsScheduler implements ReminderScheduler {
  static const _reminderId = 1001;

  final _plugin = FlutterLocalNotificationsPlugin();
  Future<void>? _ready;

  Future<void> _init() => _ready ??= () async {
    tz_data.initializeTimeZones();
    try {
      final zone = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(zone.identifier));
    } catch (error) {
      // Without the zone name, use any zone with the device's current
      // offset, so reminders still fire at the right local time today.
      debugPrint('Reminder time zone lookup failed: $error');
      final zone = _zoneWithOffset(DateTime.now().timeZoneOffset);
      if (zone != null) {
        tz.setLocalLocation(zone);
      }
    }
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
    );
  }();

  @override
  Future<bool> requestPermission() async {
    await _init();
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android != null) {
      return await android.requestNotificationsPermission() ?? false;
    }
    final ios = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    return await ios?.requestPermissions(alert: true, sound: true) ?? false;
  }

  @override
  Future<void> scheduleDaily({
    required int hour,
    required int minute,
    required String title,
    required String body,
    required String channelName,
  }) async {
    await _init();
    final now = tz.TZDateTime.now(tz.local);
    var next = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    if (!next.isAfter(now)) {
      next = next.add(const Duration(days: 1));
    }
    await _plugin.zonedSchedule(
      id: _reminderId,
      title: title,
      body: body,
      scheduledDate: next,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails('daily_reminder', channelName),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  @override
  Future<void> cancel() async {
    await _init();
    await _plugin.cancel(id: _reminderId);
  }
}

tz.Location? _zoneWithOffset(Duration offset) {
  final now = DateTime.now().millisecondsSinceEpoch;
  for (final location in tz.timeZoneDatabase.locations.values) {
    if (location.timeZone(now).offset == offset) {
      return location;
    }
  }
  return null;
}
