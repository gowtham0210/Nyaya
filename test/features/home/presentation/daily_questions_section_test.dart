import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:nyaya/core/network/api_client.dart';
import 'package:nyaya/features/home/data/daily_questions_repository.dart';
import 'package:nyaya/features/home/presentation/daily_questions_view_model.dart';
import 'package:nyaya/features/home/presentation/home_page.dart';
import 'package:nyaya/features/home/presentation/home_view_model.dart';

import '../../../support/fake_backend.dart';

const twoQuestions = {
  '/daily-questions/random': {
    'items': [
      {
        'id': 1,
        'category': 'Constitutional Law',
        'question': 'Which article protects the right to life?',
        'answer': 'Article 21.',
      },
      {
        'id': 2,
        'category': 'Criminal Law',
        'question': 'What replaced the IPC in 2024?',
        'answer': 'The Bharatiya Nyaya Sanhita.',
      },
    ],
  },
};

void main() {
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
    final dailyQuestions = DailyQuestionsViewModel(
      repository: DailyQuestionsRepository(client),
    );
    addTearDown(dailyQuestions.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: HomePage(
          viewModel: const HomeViewModel(),
          dailyQuestions: dailyQuestions,
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

  testWidgets(
    'AC-004 shows each question with its category and the count; answers hidden',
    (tester) async {
      await pumpHome(tester, fakeBackend(twoQuestions));
      await scrollTo(
        tester,
        find.byKey(const ValueKey('home.daily.question.2')),
      );

      expect(find.text('Daily Questions'), findsOneWidget);
      expect(find.text('2 Questions'), findsOneWidget);
      expect(
        find.text('Which article protects the right to life?'),
        findsOneWidget,
      );
      expect(find.text('What replaced the IPC in 2024?'), findsOneWidget);
      expect(
        find.descendant(
          of: find.byKey(const ValueKey('home.section.daily')),
          matching: find.text('Criminal Law'),
        ),
        findsOneWidget,
      );
      expect(find.text('Article 21.'), findsNothing);
      expect(find.text('The Bharatiya Nyaya Sanhita.'), findsNothing);
    },
  );

  testWidgets('AC-005 tapping a question shows its answer; again hides it', (
    tester,
  ) async {
    await pumpHome(tester, fakeBackend(twoQuestions));
    final question = find.byKey(const ValueKey('home.daily.question.1'));
    await scrollTo(tester, question);

    await tester.tap(question);
    await tester.pumpAndSettle();
    expect(find.text('Article 21.'), findsOneWidget);
    expect(find.text('Hide answer'), findsOneWidget);
    expect(find.text('The Bharatiya Nyaya Sanhita.'), findsNothing);

    await tester.tap(question);
    await tester.pumpAndSettle();
    expect(find.text('Article 21.'), findsNothing);
  });

  testWidgets('AC-006 offline shows a message; Retry loads the questions', (
    tester,
  ) async {
    var online = false;
    final client = ApiClient(
      httpClient: MockClient((request) async {
        if (!online) {
          throw http.ClientException('offline');
        }
        return http.Response(
          '{"items":[{"id":3,"category":"Civil Law",'
          '"question":"What is a tort?","answer":"A civil wrong."}]}',
          200,
        );
      }),
    );
    await pumpHome(tester, client);
    final section = find.byKey(const ValueKey('home.section.daily'));
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

    expect(find.text('What is a tort?'), findsOneWidget);
    expect(find.text('1 Question'), findsOneWidget);
  });

  testWidgets('AC-006 no questions shows the empty message', (tester) async {
    await pumpHome(
      tester,
      fakeBackend({
        '/daily-questions/random': {'items': []},
      }),
    );
    await scrollTo(tester, find.byKey(const ValueKey('home.section.daily')));

    expect(find.text('No questions available yet.'), findsOneWidget);
    expect(find.byKey(const ValueKey('home.daily.count')), findsNothing);
  });

  testWidgets('AC-007 the rest of Home renders while questions load', (
    tester,
  ) async {
    final pending = Completer<http.Response>();
    await pumpHome(
      tester,
      ApiClient(httpClient: MockClient((_) => pending.future)),
      settle: false,
    );

    expect(find.byKey(const ValueKey('home.hero.cta')), findsOneWidget);
    expect(find.text('Explore by Category'), findsOneWidget);
    // Plain pumps: settling would let the request time out.
    await tester.drag(
      find.byKey(const ValueKey('home.scroll')),
      const Offset(0, -700),
    );
    await tester.pump();
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('home.section.daily')),
        matching: find.byKey(const ValueKey('loadState.loading')),
      ),
      findsOneWidget,
    );

    pending.complete(http.Response('{"items":[]}', 200));
    await tester.pumpAndSettle();
  });

  testWidgets('AC-007 the rest of Home renders when questions fail', (
    tester,
  ) async {
    await pumpHome(
      tester,
      fakeBackend({
        '/daily-questions/random': http.Response('{"message":"down"}', 500),
      }),
    );

    expect(find.byKey(const ValueKey('home.hero.cta')), findsOneWidget);
    expect(find.text('Explore by Category'), findsOneWidget);
    await scrollTo(tester, find.byKey(const ValueKey('home.section.daily')));
    expect(
      find.text('Something went wrong. Please try again.'),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('loadState.retry')), findsOneWidget);
  });

  testWidgets('AC-008 each question is a labelled button with expanded state', (
    tester,
  ) async {
    await pumpHome(tester, fakeBackend(twoQuestions));
    final question = find.byKey(const ValueKey('home.daily.question.2'));
    await scrollTo(tester, question);

    expect(
      tester.getSemantics(question),
      isSemantics(
        isButton: true,
        hasTapAction: true,
        hasExpandedState: true,
        isExpanded: false,
        label: 'Question 2: What replaced the IPC in 2024?. Criminal Law',
      ),
    );

    await tester.tap(question);
    await tester.pumpAndSettle();

    expect(
      tester.getSemantics(question),
      isSemantics(
        isButton: true,
        hasTapAction: true,
        hasExpandedState: true,
        isExpanded: true,
        label: 'Question 2: What replaced the IPC in 2024?. Criminal Law',
      ),
    );
  });

  testWidgets('long text fits a small phone with the answer shown', (
    tester,
  ) async {
    final long = List.filled(12, 'Constitutional').join(' ');
    await pumpHome(
      tester,
      size: const Size(320, 640),
      fakeBackend({
        '/daily-questions/random': {
          'items': [
            {'id': 1, 'category': long, 'question': long, 'answer': long},
          ],
        },
      }),
    );
    final question = find.byKey(const ValueKey('home.daily.question.1'));
    await scrollTo(tester, question);

    await tester.tap(question);
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('home.daily.answer.1')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
