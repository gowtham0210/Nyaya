import 'package:nyaya/features/settings/data/reminder_scheduler.dart';

/// Records what would be scheduled; [granted] answers the permission ask.
class FakeReminderScheduler implements ReminderScheduler {
  FakeReminderScheduler({this.granted = true});

  bool granted;

  /// When set, every call throws it.
  Object? failure;
  var permissionAsks = 0;

  /// The scheduled reminder, or null when none is.
  ({int hour, int minute, String title, String body})? scheduled;

  @override
  Future<bool> requestPermission() async {
    permissionAsks++;
    _failIfSet();
    return granted;
  }

  @override
  Future<void> scheduleDaily({
    required int hour,
    required int minute,
    required String title,
    required String body,
    required String channelName,
  }) async {
    _failIfSet();
    scheduled = (hour: hour, minute: minute, title: title, body: body);
  }

  @override
  Future<void> cancel() async {
    _failIfSet();
    scheduled = null;
  }

  void _failIfSet() {
    final error = failure;
    if (error != null) {
      throw error;
    }
  }
}
