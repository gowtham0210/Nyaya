import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nyaya/features/settings/data/reminder_settings.dart';
import 'package:nyaya/features/settings/presentation/reminders_page.dart';
import 'package:nyaya/features/settings/presentation/reminders_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../support/fake_reminder_scheduler.dart';
import '../../../support/localized_app.dart';

void main() {
  late FakeReminderScheduler scheduler;

  Future<void> pumpPage(
    WidgetTester tester, {
    Locale locale = const Locale('en'),
  }) async {
    final viewModel = RemindersViewModel(
      scheduler: scheduler,
      store: ReminderSettingsStore(),
    );
    addTearDown(viewModel.dispose);
    await pumpLocalized(
      tester,
      RemindersPage(viewModel: viewModel),
      locale: locale,
    );
  }

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    scheduler = FakeReminderScheduler();
  });

  testWidgets('shows the saved choice', (tester) async {
    SharedPreferences.setMockInitialValues({
      'reminders.enabled': true,
      'reminders.hour': 20,
      'reminders.minute': 30,
    });
    await pumpPage(tester);

    expect(
      tester
          .widget<SwitchListTile>(
            find.byKey(const ValueKey('reminders.toggle')),
          )
          .value,
      isTrue,
    );
    expect(find.text('8:30 PM'), findsOneWidget);
  });

  testWidgets('turning on schedules a localized reminder', (tester) async {
    await pumpPage(tester);

    await tester.tap(find.byKey(const ValueKey('reminders.toggle')));
    await tester.pumpAndSettle();

    expect(scheduler.scheduled?.hour, 9);
    expect(scheduler.scheduled?.title, 'Nyaya');
    expect(
      scheduler.scheduled?.body,
      'Time for your daily legal practice — keep your streak going.',
    );
  });

  testWidgets('a denied permission is explained', (tester) async {
    scheduler.granted = false;
    await pumpPage(tester);

    await tester.tap(find.byKey(const ValueKey('reminders.toggle')));
    await tester.pumpAndSettle();

    expect(
      find.text(
        "Notifications are off for Nyaya. Turn them on in your phone's "
        'settings to get reminders.',
      ),
      findsOneWidget,
    );
    expect(scheduler.scheduled, isNull);
  });

  testWidgets('the time picker changes the reminder time', (tester) async {
    SharedPreferences.setMockInitialValues({'reminders.enabled': true});
    await pumpPage(tester);

    await tester.tap(find.byKey(const ValueKey('reminders.time')));
    await tester.pumpAndSettle();
    // Switch the dial to typed input, then enter 7:45 AM.
    await tester.tap(find.byIcon(Icons.keyboard_outlined));
    await tester.pumpAndSettle();
    final fields = find.byType(TextField);
    await tester.enterText(fields.at(0), '7');
    await tester.enterText(fields.at(1), '45');
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    expect(scheduler.scheduled?.hour, 7);
    expect(scheduler.scheduled?.minute, 45);
    expect(find.text('7:45 AM'), findsOneWidget);
  });

  testWidgets('strings are in Hindi', (tester) async {
    await pumpPage(tester, locale: const Locale('hi'));

    expect(find.text('दैनिक अनुस्मारक'), findsOneWidget);
  });

  testWidgets('a scheduling failure is explained', (tester) async {
    await pumpPage(tester);
    scheduler.failure = Exception('plugin');

    await tester.tap(find.byKey(const ValueKey('reminders.toggle')));
    await tester.pumpAndSettle();

    expect(
      find.text("Couldn't set the reminder. Please try again."),
      findsOneWidget,
    );
  });

  testWidgets('the switch is labelled and fits large text', (tester) async {
    tester.platformDispatcher.textScaleFactorTestValue = 1.6;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await pumpPage(tester);
    tester.view.physicalSize = const Size(320, 640);
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(
      tester.getSemantics(find.byKey(const ValueKey('reminders.toggle'))),
      isSemantics(hasToggledState: true, isToggled: false, hasTapAction: true),
    );
  });
}
