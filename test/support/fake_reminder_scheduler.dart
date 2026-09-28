import 'package:nyaya/features/settings/data/reminder_scheduler.dart';

/// Records what would be scheduled; [granted] answers the permission ask.
class FakeReminderScheduler implements ReminderScheduler {
  FakeReminderScheduler({this.granted = true});

  bool granted;
  var permissionAsks = 0;

  /// The scheduled reminder, or null when none is.
  ({int hour, int minute, String title, String body})? scheduled;

  @override
  Future<bool> requestPermission() async {
    permissionAsks++;
    return granted;
  }

  @override
  Future<void> scheduleDaily({
    required int hour,
    required int minute,
    required String title,
    required String body,
  }) async {
    scheduled = (hour: hour, minute: minute, title: title, body: body);
  }

  @override
  Future<void> cancel() async => scheduled = null;
}
