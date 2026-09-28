import 'package:flutter_test/flutter_test.dart';
import 'package:nyaya/features/settings/data/reminder_settings.dart';
import 'package:nyaya/features/settings/presentation/reminders_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../support/fake_reminder_scheduler.dart';

const text = (
  title: 'Nyaya',
  body: 'Practise today',
  channelName: 'Daily practice reminder',
);

void main() {
  late FakeReminderScheduler scheduler;

  Future<RemindersViewModel> loaded() async {
    final viewModel = RemindersViewModel(
      scheduler: scheduler,
      store: ReminderSettingsStore(),
    );
    await viewModel.load();
    return viewModel;
  }

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    scheduler = FakeReminderScheduler();
  });

  test('starts off at 9:00', () async {
    final viewModel = await loaded();

    expect(viewModel.settings.enabled, isFalse);
    expect((viewModel.settings.hour, viewModel.settings.minute), (9, 0));
  });

  test('turning on asks permission, schedules and persists', () async {
    final viewModel = await loaded();

    await viewModel.setEnabled(true, text);

    expect(scheduler.permissionAsks, 1);
    expect(scheduler.scheduled, (
      hour: 9,
      minute: 0,
      title: 'Nyaya',
      body: 'Practise today',
    ));
    expect(viewModel.settings.enabled, isTrue);
    expect((await loaded()).settings.enabled, isTrue);
  });

  test('a denied permission stays off and says so', () async {
    scheduler.granted = false;
    final viewModel = await loaded();

    await viewModel.setEnabled(true, text);

    expect(viewModel.settings.enabled, isFalse);
    expect(viewModel.permissionDenied, isTrue);
    expect(scheduler.scheduled, isNull);
  });

  test('turning off cancels and persists', () async {
    final viewModel = await loaded();
    await viewModel.setEnabled(true, text);

    await viewModel.setEnabled(false, text);

    expect(scheduler.scheduled, isNull);
    expect((await loaded()).settings.enabled, isFalse);
  });

  test('a new time reschedules when on and persists', () async {
    final viewModel = await loaded();
    await viewModel.setEnabled(true, text);

    await viewModel.setTime(hour: 20, minute: 30, text: text);

    expect(scheduler.scheduled?.hour, 20);
    expect(scheduler.scheduled?.minute, 30);
    final reloaded = await loaded();
    expect((reloaded.settings.hour, reloaded.settings.minute), (20, 30));
  });

  test('a new time while off schedules nothing', () async {
    final viewModel = await loaded();

    await viewModel.setTime(hour: 7, minute: 15, text: text);

    expect(scheduler.scheduled, isNull);
    expect(viewModel.settings.hour, 7);
  });

  test('a scheduling failure keeps the old choice and flags it', () async {
    final viewModel = await loaded();
    scheduler.failure = Exception('plugin');

    await viewModel.setEnabled(true, text);

    expect(viewModel.settings.enabled, isFalse);
    expect(viewModel.failed, isTrue);
    expect(viewModel.busy, isFalse);
  });

  test('it is not ready until settings load', () async {
    final viewModel = RemindersViewModel(
      scheduler: scheduler,
      store: ReminderSettingsStore(),
    );
    expect(viewModel.ready, isFalse);

    await viewModel.load();

    expect(viewModel.ready, isTrue);
  });

  test('closing mid-request does not throw', () async {
    final viewModel = RemindersViewModel(
      scheduler: scheduler,
      store: ReminderSettingsStore(),
    );
    final loading = viewModel.load();
    viewModel.dispose();

    await loading;
  });
}
