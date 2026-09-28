import 'package:shared_preferences/shared_preferences.dart';

/// The learner's reminder choice. Off at 9:00 by default.
class ReminderSettings {
  const ReminderSettings({
    this.enabled = false,
    this.hour = 9,
    this.minute = 0,
  });

  final bool enabled;
  final int hour;
  final int minute;

  ReminderSettings copyWith({bool? enabled, int? hour, int? minute}) =>
      ReminderSettings(
        enabled: enabled ?? this.enabled,
        hour: hour ?? this.hour,
        minute: minute ?? this.minute,
      );
}

/// Keeps [ReminderSettings] on the device.
class ReminderSettingsStore {
  static const _enabledKey = 'reminders.enabled';
  static const _hourKey = 'reminders.hour';
  static const _minuteKey = 'reminders.minute';

  Future<ReminderSettings> read() async {
    final prefs = await SharedPreferences.getInstance();
    const defaults = ReminderSettings();
    return ReminderSettings(
      enabled: prefs.getBool(_enabledKey) ?? defaults.enabled,
      hour: prefs.getInt(_hourKey) ?? defaults.hour,
      minute: prefs.getInt(_minuteKey) ?? defaults.minute,
    );
  }

  Future<void> write(ReminderSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_enabledKey, settings.enabled);
    await prefs.setInt(_hourKey, settings.hour);
    await prefs.setInt(_minuteKey, settings.minute);
  }
}
