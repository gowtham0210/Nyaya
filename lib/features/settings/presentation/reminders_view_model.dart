import 'package:flutter/foundation.dart';

import '../data/reminder_scheduler.dart';
import '../data/reminder_settings.dart';

export '../data/reminder_settings.dart' show ReminderSettings;

/// The reminder's words and Android channel name, in the app language.
typedef ReminderText = ({String title, String body, String channelName});

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
  var _disposed = false;

  ReminderSettings get settings => _settings;
  var _settings = const ReminderSettings();

  /// False until the saved settings load, so a change can't overwrite them.
  bool get ready => _ready;
  var _ready = false;

  /// True while asking permission or scheduling.
  bool get busy => _busy;
  var _busy = false;

  /// True after the learner turned reminders on but refused permission.
  bool get permissionDenied => _permissionDenied;
  var _permissionDenied = false;

  /// True when the last change couldn't be scheduled or saved.
  bool get failed => _failed;
  var _failed = false;

  Future<void> load() async {
    _settings = await _store.read();
    _ready = true;
    _notify();
  }

  Future<void> setEnabled(bool enabled, ReminderText text) => _change(() async {
    if (enabled && !await _scheduler.requestPermission()) {
      _permissionDenied = true;
      return;
    }
    await _apply(_settings.copyWith(enabled: enabled), text);
  });

  Future<void> setTime({
    required int hour,
    required int minute,
    required ReminderText text,
  }) => _change(
    () => _apply(_settings.copyWith(hour: hour, minute: minute), text),
  );

  /// Runs one change at a time, turning plugin errors into [failed].
  Future<void> _change(Future<void> Function() change) async {
    if (_busy) {
      return;
    }
    _busy = true;
    _permissionDenied = false;
    _failed = false;
    _notify();
    try {
      await change();
    } catch (error) {
      debugPrint('Reminder change failed: $error');
      _failed = true;
    } finally {
      _busy = false;
      _notify();
    }
  }

  Future<void> _apply(ReminderSettings settings, ReminderText text) async {
    if (settings.enabled) {
      await _scheduler.scheduleDaily(
        hour: settings.hour,
        minute: settings.minute,
        title: text.title,
        body: text.body,
        channelName: text.channelName,
      );
    } else {
      await _scheduler.cancel();
    }
    await _store.write(settings);
    _settings = settings;
  }

  /// The page may close mid-request.
  void _notify() {
    if (!_disposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
