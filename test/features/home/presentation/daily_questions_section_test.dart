import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:nyaya/core/network/api_client.dart';
import 'package:nyaya/features/home/data/daily_questions_repository.dart';
import 'package:nyaya/features/home/presentation/daily_questions_view_model.dart';
import 'package:nyaya/features/home/presentation/daily_question_page.dart';
import 'package:nyaya/features/home/presentation/home_page.dart';
import 'package:nyaya/features/home/presentation/home_view_model.dart';
import 'package:nyaya/features/legal_updates/data/legal_updates_repository.dart';
import 'package:nyaya/features/legal_updates/presentation/legal_updates_view_model.dart';

import '../../../support/daily_backend.dart';
import '../../../support/fake_backend.dart';
import '../../../support/home_fixture.dart';

/// Home's compact Today's Question card (specs 018, 045, 046).
void main() {
  late int answeredCalls;

  Future<void> pumpHome(
    WidgetTester tester,
    ApiClient client, {
    bool settle = true,
    Size size = const Size(393, 852),
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    answeredCalls = 0;
    final dailyQuestions = DailyQuestionsViewModel(
      repository: DailyQuestionsRepository(client),
      onAnswered: () => answeredCalls++,
    );
    addTearDown(dailyQuestions.dispose);
    final legalUpdates = LegalUpdatesViewModel(
      repository: LegalUpdatesRepository(
        fakeBackend({
          '/legal-updates': {'items': []},
        }),
      ),
    );
    addTearDown(legalUpdates.dispose);

    final sections = quietHomeSections();
    await tester.pumpWidget(
      MaterialApp(
        home: HomePage(
          viewModel: const HomeViewModel(),
          dailyQuestions: dailyQuestions,
          legalUpdates: legalUpdates,
          progress: sections.progress,
          categories: sections.categories,
        ),
      ),
    );
    if (settle) {
      await tester.pumpAndSettle();
    } else {
      await tester.pump();
    }
  }

  Future<void> scrollTo(WidgetTester tester, Finder finder) async {
    await tester.scrollUntilVisible(
      finder,
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
  }

  /// Sends a copy of [request] through [client] (a sent request can't be
  /// sent again).
  Future<http.Response> forward(
    http.Client client,
    http.Request request,
  ) async {
    final copy = http.Request(request.method, request.url)
      ..headers.addAll(request.headers)
      ..bodyBytes = request.bodyBytes;
    return http.Response.fromStream(await client.send(copy));
  }

  Finder card() => find.byKey(const ValueKey('home.section.daily'));

  testWidgets('spec 046 the card previews the question; no options on Home', (
    tester,
  ) async {
    await pumpHome(tester, fakeBackend(dailyRoutes()));
    await scrollTo(tester, card());

    expect(find.text("Today's Question"), findsOneWidget);
    expect(
      find.text('Which article protects the right to life?'),
      findsOneWidget,
    );
    expect(find.text('Constitutional Law · +10 points'), findsOneWidget);
    expect(find.byKey(const ValueKey('home.daily.answerNow')), findsOneWidget);
    expect(find.text('Article 21'), findsNothing);
    expect(
      tester.getSemantics(card()),
      isSemantics(
        isButton: true,
        hasTapAction: true,
        label: "Today's Question. Which article protects the right to life?",
        hint: 'Answer now',
      ),
    );
    // Compact: well under half the old full card.
    expect(tester.getSize(card()).height, lessThan(140));
  });

  testWidgets('spec 046 tapping opens the screen; answering updates Home', (
    tester,
  ) async {
    await pumpHome(tester, fakeBackend(dailyRoutes()));
    await scrollTo(tester, card());

    await tester.tap(card());
    await tester.pumpAndSettle();
    expect(find.byType(DailyQuestionPage), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('home.daily.option.12')));
    await tester.pumpAndSettle();
    expect(find.text('Correct!'), findsOneWidget);
    expect(answeredCalls, 1);

    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('Answered · Correct!'), findsOneWidget);
    expect(find.text('+10 earned · New question tomorrow'), findsOneWidget);
    expect(find.byKey(const ValueKey('home.daily.answerNow')), findsNothing);
  });

  testWidgets('spec 046 an answered day shows the result on the card', (
    tester,
  ) async {
    await pumpHome(tester, fakeBackend(dailyRoutes(answeredWith: 11)));
    await scrollTo(tester, card());

    expect(find.text('Answered · Not quite'), findsOneWidget);
    expect(find.text('New question tomorrow'), findsOneWidget);
  });

  testWidgets('spec 046 no question today: a quiet card that stays put', (
    tester,
  ) async {
    await pumpHome(
      tester,
      fakeBackend({'/daily-questions/today': noDailyQuestion}),
    );
    await scrollTo(tester, card());

    expect(
      find.text('No question today. Check back tomorrow.'),
      findsOneWidget,
    );
    await tester.tap(card());
    await tester.pumpAndSettle();
    expect(find.byType(DailyQuestionPage), findsNothing);
  });

  testWidgets('018 offline shows a message; Retry loads the question', (
    tester,
  ) async {
    var online = false;
    final backend = fakeBackendClient(dailyRoutes());
    final client = ApiClient(
      httpClient: MockClient((request) async {
        if (!online) throw http.ClientException('offline');
        return forward(backend, request);
      }),
    );
    await pumpHome(tester, client);
    await scrollTo(tester, card());

    expect(
      find.descendant(
        of: card(),
        matching: find.text(
          "Can't reach the Nyaya server. Check your connection and try again.",
        ),
      ),
      findsOneWidget,
    );

    online = true;
    await tester.tap(find.byKey(const ValueKey('loadState.retry')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('home.daily.answerNow')), findsOneWidget);
  });

  testWidgets('018 the rest of Home renders while the question loads', (
    tester,
  ) async {
    final pending = Completer<http.Response>();
    await pumpHome(
      tester,
      ApiClient(httpClient: MockClient((_) => pending.future)),
      settle: false,
    );

    expect(find.byKey(const ValueKey('home.continue.card')), findsOneWidget);
    expect(
      find.descendant(
        of: card(),
        matching: find.byKey(const ValueKey('loadState.loading')),
      ),
      findsOneWidget,
    );

    pending.complete(http.Response('{"question":null}', 200));
    await tester.pumpAndSettle();
  });

  testWidgets('spec 046 the card fits large text on a small phone', (
    tester,
  ) async {
    tester.platformDispatcher.textScaleFactorTestValue = 1.6;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await pumpHome(
      tester,
      fakeBackend(dailyRoutes()),
      size: const Size(360, 740),
    );
    await scrollTo(tester, card());

    expect(tester.takeException(), isNull);
    expect(find.byKey(const ValueKey('home.daily.answerNow')), findsOneWidget);
  });
}
