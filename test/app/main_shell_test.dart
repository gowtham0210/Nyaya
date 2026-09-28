import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nyaya/app/app_session.dart';
import 'package:nyaya/app/main_shell.dart';
import 'package:nyaya/core/network/api_client.dart';
import 'package:nyaya/features/settings/presentation/language_page.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:nyaya/core/localization/l10n.dart';
import 'package:nyaya/features/auth/presentation/sign_in_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../support/fake_backend.dart';
import '../support/profile_backend.dart';

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
            ...profileRoutes(),
            '/articles': {
              'items': [
                {
                  'id': 1,
                  'part': 'III',
                  'partTitle': 'Fundamental Rights',
                  'title': 'Right to Equality',
                  'articleRange': 'Articles 14–18',
                  'description': 'Equality before law.',
                  'whyItMatters': 'It stops discrimination.',
                },
              ],
            },
            '/legal-updates': {
              'items': [
                {
                  'id': 1,
                  'category': 'Notices',
                  'title': 'Court holiday notice',
                  'summary': 'Courts close on Friday.',
                  'updateDate': '2026-09-25',
                },
              ],
            },
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

  testWidgets('026 AC-007 View All recommended opens the grid', (tester) async {
    await pumpMainShell(tester);
    final viewAll = find.byKey(
      const ValueKey('home.section.recommended.viewAll'),
    );
    await tester.scrollUntilVisible(
      viewAll,
      300,
      scrollable: find
          .descendant(
            of: find.byKey(const ValueKey('home.scroll')),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    await tester.pumpAndSettle();

    await tester.tap(viewAll);
    await tester.pumpAndSettle();

    expect(
      find.descendant(
        of: find.byType(AppBar),
        matching: find.text('Recommended for you'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('020 AC-005 View All legal updates opens the full list', (
    tester,
  ) async {
    await pumpMainShell(tester);
    final viewAll = find.byKey(
      const ValueKey('home.section.legalUpdates.viewAll'),
    );
    await tester.scrollUntilVisible(
      viewAll,
      300,
      scrollable: find
          .descendant(
            of: find.byKey(const ValueKey('home.scroll')),
            matching: find.byType(Scrollable),
          )
          .first,
    );

    await tester.tap(viewAll);
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('legalUpdates.list')), findsOneWidget);
    expect(find.text('Court holiday notice'), findsOneWidget);

    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('home.scroll')), findsOneWidget);
  });

  testWidgets('019 the Articles tab lists articles and opens one', (
    tester,
  ) async {
    await pumpMainShell(tester);

    await tester.tap(find.byKey(const ValueKey('nav.articles')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('articles.item.1')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('articles.item.1.read')));
    await tester.pumpAndSettle();

    expect(find.text('Why it matters'), findsOneWidget);
    expect(find.text('It stops discrimination.'), findsOneWidget);
  });

  testWidgets('021 Profile shows the learner and logs out to sign-in', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    await AppSession.saveSignedIn();
    await pumpMainShell(tester);

    await tester.tap(find.byKey(const ValueKey('nav.profile')));
    await tester.pumpAndSettle();
    expect(find.text('Asha Rao'), findsOneWidget);

    final logout = find.byKey(const ValueKey('profile.logout'));
    await tester.scrollUntilVisible(
      logout,
      200,
      scrollable: find
          .descendant(
            of: find.byKey(const ValueKey('profile.scroll')),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    await tester.pumpAndSettle();
    await tester.tap(logout);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('profile.logout.confirm')));
    await tester.pumpAndSettle();

    expect(find.byType(SignInPage), findsOneWidget);
    expect(AppSession.signedIn, isFalse);
  });

  testWidgets('027 Edit profile opens from Profile, pre-filled', (
    tester,
  ) async {
    await pumpMainShell(tester);
    await tester.tap(find.byKey(const ValueKey('nav.profile')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('profile.edit')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('editProfile.save')), findsOneWidget);
    expect(
      tester
          .widget<TextFormField>(find.byKey(const ValueKey('editProfile.name')))
          .controller!
          .text,
      'Asha Rao',
    );
  });

  testWidgets('028 picking Hindi switches the app and reloads content', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final language = ValueNotifier(const Locale('en'));
    addTearDown(language.dispose);
    final categoryLangs = <String?>[];
    final routes = <String, Object>{
      '/categories': {'items': []},
      ...profileRoutes(),
    };
    tester.view.physicalSize = const Size(393, 852);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ValueListenableBuilder<Locale>(
        valueListenable: language,
        builder: (context, locale, _) => MaterialApp(
          locale: locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: MainShell(
            language: language,
            selectLanguage: (code) async => language.value = Locale(code),
            apiClient: ApiClient(
              languageCode: () => language.value.languageCode,
              httpClient: MockClient((request) async {
                final path = request.url.path.replaceFirst('/api/v1', '');
                if (path == '/categories') {
                  categoryLangs.add(request.url.queryParameters['lang']);
                }
                final route = routes[path];
                return route == null
                    ? http.Response('{}', 404)
                    : http.Response(jsonEncode(route), 200);
              }),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(categoryLangs, [null]);

    await tester.tap(find.byKey(const ValueKey('nav.profile')));
    await tester.pumpAndSettle();
    final entry = find.byKey(const ValueKey('profile.entry.language'));
    await tester.scrollUntilVisible(
      entry,
      200,
      scrollable: find
          .descendant(
            of: find.byKey(const ValueKey('profile.scroll')),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    await tester.pumpAndSettle();
    await tester.tap(entry);
    await tester.pumpAndSettle();
    await tester.tap(find.text('हिन्दी'));
    await tester.pumpAndSettle();

    // Back on Profile, now in Hindi, with content reloaded in Hindi.
    expect(find.byType(LanguagePage), findsNothing);
    expect(find.text('मेरे आंकड़े'), findsOneWidget);
    expect(categoryLangs, [null, 'hi']);
  });

  testWidgets('AC-006 unbuilt tabs show the coming-soon state', (tester) async {
    await pumpMainShell(tester);

    for (final id in ['leaderboard']) {
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
