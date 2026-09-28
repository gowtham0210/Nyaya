import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:nyaya/features/profile/data/profile_repository.dart';
import 'package:nyaya/features/profile/presentation/profile_page.dart';
import 'package:nyaya/features/profile/presentation/profile_view_model.dart';

import '../../../support/fake_backend.dart';
import '../../../support/localized_app.dart';
import '../../../support/profile_backend.dart';

void main() {
  late List<ProfileEntry> selected;
  late int logouts;

  Future<void> pumpPage(
    WidgetTester tester,
    Map<String, Object> routes, {
    Locale locale = const Locale('en'),
  }) async {
    final viewModel = ProfileViewModel(
      repository: ProfileRepository(fakeBackend(routes)),
    );
    addTearDown(viewModel.dispose);
    selected = [];
    logouts = 0;
    await pumpLocalized(
      tester,
      ProfilePage(
        viewModel: viewModel,
        onEntrySelected: selected.add,
        onLogout: () async => logouts++,
      ),
      locale: locale,
    );
  }

  Finder scrollable() => find
      .descendant(
        of: find.byKey(const ValueKey('profile.scroll')),
        matching: find.byType(Scrollable),
      )
      .first;

  Future<void> scrollTo(WidgetTester tester, Finder target) async {
    await tester.scrollUntilVisible(target, 200, scrollable: scrollable());
    await tester.pumpAndSettle();
  }

  testWidgets('AC-003 shows name, profession, initials and stats', (
    tester,
  ) async {
    await pumpPage(tester, profileRoutes());

    expect(find.text('Asha Rao'), findsOneWidget);
    expect(find.text('Law Student'), findsOneWidget);
    expect(find.text('AR'), findsOneWidget);
    for (final (id, label, value) in [
      ('streak', 'Day streak', '4'),
      ('categories', 'Categories explored', '3'),
      ('quizzes', 'Quizzes completed', '9'),
      ('points', 'Points earned', '320'),
    ]) {
      final tile = find.byKey(ValueKey('profile.stat.$id'));
      expect(
        find.descendant(of: tile, matching: find.text(value)),
        findsOneWidget,
        reason: id,
      );
      expect(
        find.descendant(of: tile, matching: find.text(label)),
        findsOneWidget,
        reason: id,
      );
    }
  });

  testWidgets('AC-003 a photo that fails to load falls back to initials', (
    tester,
  ) async {
    await pumpPage(tester, profileRoutes(avatarUrl: '/uploads/7.png'));

    expect(find.text('AR'), findsOneWidget);
  });

  testWidgets('AC-004 entries report their taps', (tester) async {
    await pumpPage(tester, profileRoutes());

    await tester.tap(find.byKey(const ValueKey('profile.edit')));
    final listed = ProfileEntry.values.where(
      (entry) => entry != ProfileEntry.editProfile,
    );
    for (final entry in listed) {
      final tile = find.byKey(ValueKey('profile.entry.${entry.name}'));
      await scrollTo(tester, tile);
      await tester.tap(tile);
    }

    expect(selected, ProfileEntry.values);
  });

  testWidgets('AC-005 logout asks first; Cancel keeps the learner in', (
    tester,
  ) async {
    await pumpPage(tester, profileRoutes());
    final logout = find.byKey(const ValueKey('profile.logout'));
    await scrollTo(tester, logout);

    await tester.tap(logout);
    await tester.pumpAndSettle();
    expect(find.text('Log out of Nyaya?'), findsOneWidget);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(logouts, 0);

    await tester.tap(logout);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('profile.logout.confirm')));
    await tester.pumpAndSettle();
    expect(logouts, 1);
  });

  testWidgets('AC-006 a failure shows Retry, which reloads', (tester) async {
    final routes = profileRoutes()
      ..['/users/me'] = http.Response('{"message":"boom"}', 500);
    await pumpPage(tester, routes);
    expect(find.byKey(const ValueKey('loadState.retry')), findsOneWidget);

    routes.addAll(profileRoutes());
    await tester.tap(find.byKey(const ValueKey('loadState.retry')));
    await tester.pumpAndSettle();

    expect(find.text('Asha Rao'), findsOneWidget);
  });

  testWidgets('AC-007 strings are in Hindi', (tester) async {
    await pumpPage(tester, profileRoutes(), locale: const Locale('hi'));

    expect(find.text('मेरे आंकड़े'), findsOneWidget);
    expect(find.text('My statistics'), findsNothing);
  });

  testWidgets('fits large text on a small phone', (tester) async {
    tester.platformDispatcher.textScaleFactorTestValue = 1.6;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await pumpPage(tester, profileRoutes());
    tester.view.physicalSize = const Size(320, 640);
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });
}
