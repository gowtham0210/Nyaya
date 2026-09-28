import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nyaya/app/main_shell.dart';
import 'package:nyaya/core/localization/l10n.dart';

import '../support/fake_backend.dart';

void main() {
  Future<void> pumpMainShell(WidgetTester tester, {Locale? locale}) async {
    tester.view.physicalSize = const Size(393, 852);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      MaterialApp(
        locale: locale,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: MainShell(
          apiClient: fakeBackend({
            '/categories': {'items': []},
          }),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('AC-001 five tabs with Home active; no Bookmarks tab', (
    tester,
  ) async {
    await pumpMainShell(tester);

    final bar = find.byKey(const ValueKey('nav.bar'));
    for (final label in [
      'Home',
      'Categories',
      'Leaderboard',
      'Articles',
      'Profile',
    ]) {
      expect(
        find.descendant(of: bar, matching: find.text(label)),
        findsOneWidget,
      );
    }
    expect(find.text('Bookmarks'), findsNothing);
    expect(find.byKey(const ValueKey('nav.home.active')), findsOneWidget);
    expect(find.byKey(const ValueKey('home.header')), findsOneWidget);
  });

  testWidgets('AC-008 View all categories switches to the Categories tab', (
    tester,
  ) async {
    await pumpMainShell(tester);

    await tester.tap(
      find.descendant(
        of: find.byKey(const ValueKey('home.section.explore')),
        matching: find.text('View All'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('nav.categories.active')), findsOneWidget);
    expect(find.byKey(const ValueKey('categories.search')), findsOneWidget);
  });

  testWidgets('AC-006 unbuilt tabs show the coming-soon state', (tester) async {
    await pumpMainShell(tester);

    for (final id in ['leaderboard', 'articles', 'profile']) {
      await tester.tap(find.byKey(ValueKey('nav.$id')));
      await tester.pumpAndSettle();
      expect(find.text('Coming soon'), findsOneWidget, reason: id);
    }
  });

  testWidgets('AC-001 tab labels follow the app language', (tester) async {
    await pumpMainShell(tester, locale: const Locale('hi'));

    final bar = find.byKey(const ValueKey('nav.bar'));
    for (final label in ['होम', 'श्रेणियाँ', 'लीडरबोर्ड', 'लेख', 'प्रोफ़ाइल']) {
      expect(
        find.descendant(of: bar, matching: find.text(label)),
        findsOneWidget,
      );
    }
  });
}
