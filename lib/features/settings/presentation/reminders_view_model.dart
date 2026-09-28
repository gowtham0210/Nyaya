import 'package:flutter/foundation.dart';

import '../data/reminder_scheduler.dart';
import '../data/reminder_settings.dart';

export '../data/reminder_settings.dart' show ReminderSettings;

/// The reminder's words, in the app language.
typedef ReminderText = ({String title, String body});

/// Daily practice reminders (spec 029): on/off and time, kept on the
/// device, scheduled as a local notification.
class RemindersViewModel extends ChangeNotifier {
  RemindersViewModel({
    required ReminderScheduler scheduler,
    required ReminderSettingsStore store,
  }) : _scheduler = scheduler,
       _store = store;

  final ReminderScheduler _scheduler;
  final ReminderSettingsStore _store;

  ReminderSettings get settings => _settings;
  var _settings = const ReminderSettings();

  /// True after the learner turned reminders on but refused permission.
  bool get permissionDenied => _permissionDenied;
  var _permissionDenied = false;

  Future<void> load() async {
    _settings = await _store.read();
    notifyListeners();
  }

  Future<void> setEnabled(bool enabled, ReminderText text) async {
    _permissionDenied = false;
    if (enabled && !await _scheduler.requestPermission()) {
      _permissionDenied = true;
      notifyListeners();
      return;
    }
    await _save(_settings.copyWith(enabled: enabled), text);
  }

  Future<void> setTime({
    required int hour,
    required int minute,
    required ReminderText text,
  }) => _save(_settings.copyWith(hour: hour, minute: minute), text);

  Future<void> _save(ReminderSettings settings, ReminderText text) async {
    if (settings.enabled) {
      await _scheduler.scheduleDaily(
        hour: settings.hour,
        minute: settings.minute,
        title: text.title,
        body: text.body,
      );
    } else {
      await _scheduler.cancel();
    }
    await _store.write(settings);
    _settings = settings;
    notifyListeners();
  }
}
