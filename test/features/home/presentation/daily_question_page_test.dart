import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:nyaya/core/network/api_client.dart';
import 'package:nyaya/features/home/data/daily_questions_repository.dart';
import 'package:nyaya/features/home/presentation/daily_questions_view_model.dart';
import 'package:nyaya/features/home/presentation/daily_question_page.dart';

import '../../../support/daily_backend.dart';
import '../../../support/fake_backend.dart';

/// Today's question on its own screen (specs 045, 046).
void main() {
  late int answeredCalls;

  Future<void> pumpPage(
    WidgetTester tester,
    ApiClient client, {
    Size size = const Size(393, 852),
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    answeredCalls = 0;
    final viewModel = DailyQuestionsViewModel(
      repository: DailyQuestionsRepository(client),
      onAnswered: () => answeredCalls++,
    );
    addTearDown(viewModel.dispose);
    viewModel.load();
    await tester.pumpWidget(
      MaterialApp(home: DailyQuestionPage(viewModel: viewModel)),
    );
    await tester.pumpAndSettle();
  }

  Future<void> scrollTo(WidgetTester tester, Finder finder) async {
    await tester.scrollUntilVisible(
      finder,
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
  }

  List<String> recordHaptics(WidgetTester tester) {
    final haptics = <String>[];
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'HapticFeedback.vibrate') {
          haptics.add(call.arguments as String);
        }
        return null;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );
    return haptics;
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

  Finder option(int id) => find.byKey(ValueKey('home.daily.option.$id'));

  Future<void> pick(WidgetTester tester, int id) async {
    await tester.tap(option(id));
    await tester.pumpAndSettle();
  }

  testWidgets('AC-003 shows the question and options; no answer shown', (
    tester,
  ) async {
    await pumpPage(tester, fakeBackend(dailyRoutes()));
    await scrollTo(tester, option(13));

    // The title sits in the app bar.
    expect(find.text("Today's Question"), findsOneWidget);
    expect(find.byKey(const ValueKey('daily.page')), findsOneWidget);
    expect(find.text('+10 points'), findsOneWidget);
    expect(find.text('Constitutional Law'), findsOneWidget);
    expect(
      find.text('Which article protects the right to life?'),
      findsOneWidget,
    );
    expect(find.text('Article 21'), findsOneWidget);
    expect(find.text('Show answer'), findsNothing);
    expect(find.byKey(const ValueKey('home.daily.explanation')), findsNothing);
    expect(
      tester.getSemantics(option(11)),
      isSemantics(
        isButton: true,
        hasTapAction: true,
        label: 'Option A. Article 14',
      ),
    );
  });

  testWidgets('AC-003 a right pick turns green and earns points', (
    tester,
  ) async {
    final haptics = recordHaptics(tester);
    final answers = <int>[];
    await pumpPage(tester, fakeBackend(dailyRoutes(answers: answers)));
    await scrollTo(tester, option(13));

    await pick(tester, 12);

    expect(answers, [12]);
    expect(find.text('Correct!'), findsOneWidget);
    expect(
      find.text('Article 21 protects life and personal liberty.'),
      findsOneWidget,
    );
    expect(find.text('+10 earned'), findsOneWidget);
    expect(find.text('+10 points'), findsNothing);
    expect(
      tester.getSemantics(option(12)),
      isSemantics(label: 'Option B. Article 21', value: 'Your answer, correct'),
    );
    expect(haptics, [
      'HapticFeedbackType.selectionClick',
      'HapticFeedbackType.lightImpact',
    ]);
    expect(answeredCalls, 1);

    // Locked: another tap sends nothing.
    await pick(tester, 11);
    expect(answers, [12]);
  });

  testWidgets('AC-003 a wrong pick turns red and marks the right one', (
    tester,
  ) async {
    final haptics = recordHaptics(tester);
    await pumpPage(tester, fakeBackend(dailyRoutes()));
    await scrollTo(tester, option(13));

    await pick(tester, 13);

    expect(find.text('Not quite'), findsOneWidget);
    expect(find.byKey(const ValueKey('home.daily.earned')), findsNothing);
    expect(
      tester.getSemantics(option(13)),
      isSemantics(label: 'Option C. Article 32', value: 'Your answer, wrong'),
    );
    expect(
      tester.getSemantics(option(12)),
      isSemantics(label: 'Option B. Article 21', value: 'Correct answer'),
    );
    expect(haptics.last, 'HapticFeedbackType.mediumImpact');
    expect(find.text('Come back tomorrow for a new question.'), findsOneWidget);
  });

  testWidgets('FR-002 the pick shows a spinner while it is graded', (
    tester,
  ) async {
    final reply = Completer<http.Response>();
    final backend = fakeBackendClient(dailyRoutes());
    final client = ApiClient(
      httpClient: MockClient(
        (request) =>
            request.method == 'POST' ? reply.future : forward(backend, request),
      ),
    );
    await pumpPage(tester, client);
    await scrollTo(tester, option(13));

    await tester.tap(option(12));
    await tester.pump();

    expect(find.byKey(const ValueKey('home.daily.sending')), findsOneWidget);
    expect(tester.getSemantics(option(11)), isNot(isSemantics(isButton: true)));
    reply.complete(http.Response('{"message":"x"}', 500));
    await tester.pumpAndSettle();
  });

  testWidgets('AC-002 a failed answer keeps the question and says so', (
    tester,
  ) async {
    await pumpPage(
      tester,
      fakeBackend(
        dailyRoutes(answerResponse: http.Response('{"message":"x"}', 500)),
      ),
    );
    await scrollTo(tester, option(13));

    await pick(tester, 12);

    expect(
      find.text(
        "Couldn't save your answer. Check your connection and try again.",
      ),
      findsOneWidget,
    );
    expect(find.text('Correct!'), findsNothing);
    expect(
      tester.getSemantics(option(12)),
      isSemantics(isButton: true, label: 'Option B. Article 21'),
    );
  });

  testWidgets('AC-004 an answered day shows the result, locked', (
    tester,
  ) async {
    await pumpPage(tester, fakeBackend(dailyRoutes(answeredWith: 11)));
    await scrollTo(tester, option(13));

    expect(find.text('Not quite'), findsOneWidget);
    expect(
      tester.getSemantics(option(11)),
      isSemantics(label: 'Option A. Article 14', value: 'Your answer, wrong'),
    );
    expect(find.text('+10 points'), findsNothing);
  });

  testWidgets('AC-005 no question today shows the empty message', (
    tester,
  ) async {
    await pumpPage(
      tester,
      fakeBackend({'/daily-questions/today': noDailyQuestion}),
    );
    await scrollTo(tester, find.byKey(const ValueKey('daily.view')));

    expect(
      find.text('No question today. Check back tomorrow.'),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('home.daily.points')), findsNothing);
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
    await pumpPage(tester, client);
    final section = find.byKey(const ValueKey('daily.view'));
    await scrollTo(tester, section);

    expect(
      find.descendant(
        of: section,
        matching: find.text(
          "Can't reach the Nyaya server. Check your connection and try again.",
        ),
      ),
      findsOneWidget,
    );

    online = true;
    await tester.tap(
      find.descendant(
        of: section,
        matching: find.byKey(const ValueKey('loadState.retry')),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.text('Which article protects the right to life?'),
      findsOneWidget,
    );
  });

  testWidgets('AC-005 fits a small phone with large text once answered', (
    tester,
  ) async {
    tester.platformDispatcher.textScaleFactorTestValue = 1.6;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await pumpPage(
      tester,
      size: const Size(360, 740),
      fakeBackend({
        ...dailyRoutes(),
        '/daily-questions/today': dailyToday(
          category: List.filled(8, 'Constitutional').join(' '),
        ),
      }),
    );
    await scrollTo(tester, option(13));
    await pick(tester, 13);
    await scrollTo(tester, find.byKey(const ValueKey('home.daily.comeBack')));

    expect(tester.takeException(), isNull);
  });
}
