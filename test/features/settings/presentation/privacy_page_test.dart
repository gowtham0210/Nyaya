import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:nyaya/core/network/api_client.dart';
import 'package:nyaya/features/settings/data/security_repository.dart';
import 'package:nyaya/features/settings/presentation/privacy_page.dart';
import 'package:nyaya/features/settings/presentation/privacy_view_model.dart';

import '../../../support/localized_app.dart';

void main() {
  late List<String> calls;
  late int signOuts;
  late bool online;

  Future<void> pumpPage(
    WidgetTester tester, {
    Locale locale = const Locale('en'),
  }) async {
    calls = [];
    signOuts = 0;
    online = true;
    final viewModel = PrivacyViewModel(
      repository: SecurityRepository(
        ApiClient(
          httpClient: MockClient((request) async {
            calls.add('${request.method} ${request.url.path}');
            if (!online) {
              throw http.ClientException('offline');
            }
            return http.Response('{"activeSessions":3}', 200);
          }),
        ),
      ),
    );
    addTearDown(viewModel.dispose);
    await pumpLocalized(
      tester,
      PrivacyPage(viewModel: viewModel, onSignedOut: () async => signOuts++),
      locale: locale,
    );
  }

  testWidgets('shows active sessions and that there is no password', (
    tester,
  ) async {
    await pumpPage(tester);

    expect(
      find.descendant(
        of: find.byKey(const ValueKey('privacy.sessions')),
        matching: find.text('3'),
      ),
      findsOneWidget,
    );
    expect(
      find.textContaining("there's no password to change"),
      findsOneWidget,
    );
    expect(find.textContaining('Change password'), findsNothing);
  });

  testWidgets('log out everywhere asks first; Cancel does nothing', (
    tester,
  ) async {
    await pumpPage(tester);

    await tester.tap(find.byKey(const ValueKey('privacy.logoutAll')));
    await tester.pumpAndSettle();
    expect(
      find.text('This will sign you out on every device, including this one.'),
      findsOneWidget,
    );
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(calls.where((c) => c.startsWith('POST')), isEmpty);
    expect(signOuts, 0);
  });

  testWidgets('confirming calls the backend, then signs out', (tester) async {
    await pumpPage(tester);

    await tester.tap(find.byKey(const ValueKey('privacy.logoutAll')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('privacy.logoutAll.confirm')));
    await tester.pumpAndSettle();

    expect(calls, contains('POST /api/v1/users/me/logout-all'));
    expect(signOuts, 1);
  });

  testWidgets('a failed log out stays signed in and says why', (tester) async {
    await pumpPage(tester);
    online = false;

    await tester.tap(find.byKey(const ValueKey('privacy.logoutAll')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('privacy.logoutAll.confirm')));
    await tester.pumpAndSettle();

    expect(signOuts, 0);
    expect(
      find.text(
        "Can't reach the Nyaya server. Check your connection and try again.",
      ),
      findsOneWidget,
    );
  });

  testWidgets('strings are in Hindi', (tester) async {
    await pumpPage(tester, locale: const Locale('hi'));

    expect(find.text('सक्रिय सत्र'), findsOneWidget);
  });
}
