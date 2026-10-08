import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:nyaya/features/quiz_question/data/quiz_play_repository.dart';
import 'package:nyaya/features/quiz_question/presentation/quiz_play_page.dart';
import 'package:nyaya/features/quiz_question/presentation/quiz_session_view_model.dart';

import '../../../support/fake_backend.dart';
import '../../../support/quiz_backend.dart';

void main() {
  Future<void> pumpPlay(
    WidgetTester tester,
    Map<String, Object> routes, {
    ValueChanged<List<QuizOutcome>>? onQuizCompleted,
  }) async {
    final repository = QuizPlayRepository(fakeBackend(routes));
    await tester.pumpWidget(
      MaterialApp(
        home: QuizPlayPage(
          start: () => RemoteQuizSession.start(repository, 12),
          onQuizCompleted: onQuizCompleted ?? (_) {},
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> choose(WidgetTester tester, String letter) async {
    final option = find.byKey(ValueKey('quiz.option.$letter'));
    await tester.ensureVisible(option);
    await tester.tap(option);
    await tester.pumpAndSettle();
  }

  Future<void> next(WidgetTester tester) async {
    await tester.tap(find.byKey(const ValueKey('quiz.next')));
    await tester.pumpAndSettle();
  }

  testWidgets('AC-004 a backend quiz records answers and submits once', (
    tester,
  ) async {
    final answers = <String>[];
    final submits = <String>[];
    List<QuizOutcome>? outcomes;
    await pumpPlay(
      tester,
      quizRoutes(answers: answers, submits: submits),
      onQuizCompleted: (result) => outcomes = result,
    );

    expect(find.text('Question 1 of 2'), findsOneWidget);
    expect(find.text('Who files an FIR?'), findsOneWidget);
    await choose(tester, 'B'); // 102: right
    expect(find.text('Correct!'), findsOneWidget);
    expect(find.text('Anyone can file one.'), findsOneWidget);
    await next(tester);

    await choose(tester, 'A'); // 201: wrong
    expect(find.text('Not quite'), findsOneWidget);
    expect(submits, isEmpty);
    await next(tester);

    expect(answers, hasLength(2));
    expect(submits, hasLength(1));
    expect(outcomes?.map((o) => o.isCorrect), [true, false]);
  });

  testWidgets('AC-004 a failed answer keeps the question open', (tester) async {
    final routes = quizRoutes()
      ..['/quiz-attempts/99/answers'] = http.Response('{"message":"x"}', 500);
    await pumpPlay(tester, routes);

    await choose(tester, 'B');

    expect(
      find.text(
        "Couldn't save your answer. Check your connection and try again.",
      ),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('quiz.selectbar')), findsOneWidget);
    expect(find.byKey(const ValueKey('quiz.explanation')), findsNothing);
  });

  testWidgets('AC-004 a failed submit can be retried with Next', (
    tester,
  ) async {
    var failSubmit = true;
    var completed = 0;
    final routes = quizRoutes()
      ..['/quiz-attempts/99/submit'] = (http.Request _) => failSubmit
          ? http.Response('{"message":"x"}', 500)
          : {'attempt': <String, Object>{}};
    await pumpPlay(tester, routes, onQuizCompleted: (_) => completed++);

    await choose(tester, 'B');
    await next(tester);
    await choose(tester, 'B');
    await next(tester);
    expect(completed, 0);
    expect(
      find.text(
        "Couldn't submit your quiz. Check your connection and try again.",
      ),
      findsOneWidget,
    );

    failSubmit = false;
    // The floating snackbar covers the footer until it times out.
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
    await next(tester);
    expect(completed, 1);
  });

  testWidgets('AC-004 if the quiz cannot load, Retry tries again', (
    tester,
  ) async {
    final routes = quizRoutes()
      ..['/quizzes/12/questions'] = http.Response('{"message":"x"}', 500);
    await pumpPlay(tester, routes);

    final retry = find.byKey(const ValueKey('loadState.retry'));
    expect(retry, findsOneWidget);

    routes.addAll(quizRoutes());
    await tester.tap(retry);
    await tester.pumpAndSettle();
    expect(find.text('Question 1 of 2'), findsOneWidget);
  });
}
