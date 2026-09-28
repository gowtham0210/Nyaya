import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:nyaya/core/network/api_client.dart';
import 'package:nyaya/features/legal_updates/data/legal_updates_repository.dart';
import 'package:nyaya/features/legal_updates/presentation/legal_updates_page.dart';
import 'package:nyaya/features/legal_updates/presentation/legal_updates_view_model.dart';

import '../../../support/fake_backend.dart';
import '../../../support/localized_app.dart';

String updatesJson(int count) {
  final items = [
    for (var i = 1; i <= count; i++)
      '{"id":$i,"category":"Notices","title":"Update $i",'
          '"summary":"s","updateDate":"2026-09-${i.toString().padLeft(2, '0')}"}',
  ];
  return '{"items":[${items.join(',')}]}';
}

void main() {
  Future<LegalUpdatesViewModel> pumpPage(
    WidgetTester tester,
    ApiClient client,
  ) async {
    final viewModel = LegalUpdatesViewModel(
      repository: LegalUpdatesRepository(client),
    );
    addTearDown(viewModel.dispose);
    await viewModel.load();
    await pumpLocalized(
      tester,
      LegalUpdatesPage(viewModel: viewModel),
      locale: const Locale('en'),
    );
    return viewModel;
  }

  ApiClient backendWith(String body) =>
      ApiClient(httpClient: MockClient((_) async => http.Response(body, 200)));

  testWidgets('AC-005 the list shows every update, newest first, and scrolls', (
    tester,
  ) async {
    await pumpPage(tester, backendWith(updatesJson(8)));

    expect(find.text('Legal Updates'), findsOneWidget);
    expect(find.text('Update 8'), findsOneWidget);
    expect(find.text('Update 1'), findsNothing);

    await tester.scrollUntilVisible(
      find.text('Update 1'),
      300,
      scrollable: find.descendant(
        of: find.byKey(const ValueKey('legalUpdates.list')),
        matching: find.byType(Scrollable),
      ),
    );

    expect(find.text('Update 1'), findsOneWidget);
  });

  testWidgets('AC-005 opening the list does not reload', (tester) async {
    var calls = 0;
    await pumpPage(
      tester,
      ApiClient(
        httpClient: MockClient((_) async {
          calls++;
          return http.Response(updatesJson(1), 200);
        }),
      ),
    );

    expect(calls, 1);
    expect(find.text('Update 1'), findsOneWidget);
  });

  testWidgets('AC-006 no updates shows the empty state', (tester) async {
    await pumpPage(
      tester,
      fakeBackend({
        '/legal-updates': {'items': []},
      }),
    );

    expect(find.text('No legal updates yet.'), findsOneWidget);
  });

  testWidgets('AC-006 a failure shows Retry, and Retry reloads', (
    tester,
  ) async {
    var online = false;
    await pumpPage(
      tester,
      ApiClient(
        httpClient: MockClient((_) async {
          if (!online) {
            return http.Response('{"message":"boom"}', 500);
          }
          return http.Response(updatesJson(1), 200);
        }),
      ),
    );

    expect(
      find.text('Something went wrong. Please try again.'),
      findsOneWidget,
    );

    online = true;
    await tester.tap(find.byKey(const ValueKey('loadState.retry')));
    await tester.pumpAndSettle();

    expect(find.text('Update 1'), findsOneWidget);
  });

  testWidgets('AC-006 the list shows a spinner while loading', (tester) async {
    final viewModel = LegalUpdatesViewModel(
      repository: LegalUpdatesRepository(
        ApiClient(
          httpClient: MockClient(
            (_) => Future.delayed(
              const Duration(seconds: 1),
              () => http.Response(updatesJson(1), 200),
            ),
          ),
        ),
      ),
    );
    addTearDown(viewModel.dispose);
    final loading = viewModel.load();
    await tester.pumpWidget(
      MaterialApp(home: LegalUpdatesPage(viewModel: viewModel)),
    );

    expect(find.byKey(const ValueKey('loadState.loading')), findsOneWidget);

    await tester.pump(const Duration(seconds: 1));
    await loading;
    await tester.pumpAndSettle();
    expect(find.text('Update 1'), findsOneWidget);
  });

  testWidgets('cards fit a small phone with large text', (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 1.6;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
      tester.platformDispatcher.clearTextScaleFactorTestValue();
    });
    final viewModel = LegalUpdatesViewModel(
      repository: LegalUpdatesRepository(
        fakeBackend({
          '/legal-updates': {
            'items': [
              {
                'id': 1,
                'category': 'Legislation',
                'title': 'A very long title about a new act that wraps lines',
                'summary': 'A long summary that also needs to wrap nicely.',
                'updateDate': '2026-09-20',
                'source': 'Ministry of Law and Justice, Government of India',
              },
            ],
          },
        }),
      ),
    );
    addTearDown(viewModel.dispose);
    await viewModel.load();

    await tester.pumpWidget(
      MaterialApp(home: LegalUpdatesPage(viewModel: viewModel)),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Sep 20, 2026'), findsOneWidget);
  });
}
