import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nyaya/features/quiz_question/presentation/quiz_question_page.dart';
import 'package:nyaya/features/quiz_question/presentation/quiz_session_view_model.dart';

void main() {
  Future<void> pumpQuizPage(
    WidgetTester tester, {
    QuizSessionViewModel? session,
    ValueChanged<List<QuizOutcome>>? onQuizCompleted,
    Size size = const Size(393, 852),
  }) async {
    tester.view.reset();
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    tester.view.padding = const FakeViewPadding(top: 59, bottom: 34);
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
      tester.view.resetPadding();
    });

    await tester.pumpWidget(
      MaterialApp(
        home: QuizQuestionPage(
          session: session,
          onQuizCompleted: onQuizCompleted ?? (_) {},
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  /// A two-question session: Ravi's warrant question first, then FIR.
  QuizSessionViewModel shortSession() {
    final all = QuizSessionViewModel().questions;
    return QuizSessionViewModel(questions: [all[3], all[0]]);
  }

  testWidgets('shows the unanswered question with a disabled answer bar', (
    WidgetTester tester,
  ) async {
    await pumpQuizPage(tester, session: shortSession());

    expect(find.text('Question 1 of 2'), findsOneWidget);
    expect(find.byKey(const ValueKey('quiz.exit')), findsOneWidget);
    expect(find.byKey(const ValueKey('quiz.progress')), findsOneWidget);
    expect(
      find.text(
        'The police stop Ravi at night and want to arrest him without a '
        'warrant. When is this legal under the BNSS?',
      ),
      findsOneWidget,
    );
    expect(find.text('Only if a magistrate has signed the order'),
        findsOneWidget);
    expect(find.text('For any cognizable offence, with reasons recorded'),
        findsOneWidget);
    expect(find.text('Never — a warrant is always required'), findsOneWidget);
    expect(find.text('Only between sunrise and sunset'), findsOneWidget);
    expect(find.text('SELECT AN ANSWER'), findsOneWidget);
    expect(find.text('NEXT'), findsNothing);
    expect(find.byKey(const ValueKey('quiz.explanation')), findsNothing);
  });

  testWidgets('a correct pick locks green and shows the explanation card', (
    WidgetTester tester,
  ) async {
    await pumpQuizPage(tester, session: shortSession());

    await tester.tap(find.byKey(const ValueKey('quiz.option.B')));
    await tester.pumpAndSettle();

    expect(find.text('Correct!'), findsOneWidget);
    expect(find.byKey(const ValueKey('quiz.explanation')), findsOneWidget);
    expect(find.text('BNSS §35 (formerly CrPC §41)'), findsOneWidget);
    expect(
      find.text('If arrested, you have the right to know the reason in '
          'writing.'),
      findsOneWidget,
    );
    expect(find.text('NEXT'), findsOneWidget);
    expect(find.text('SELECT AN ANSWER'), findsNothing);
  });

  testWidgets('a wrong pick shows Not quite and reveals the correct option', (
    WidgetTester tester,
  ) async {
    await pumpQuizPage(tester, session: shortSession());

    await tester.tap(find.byKey(const ValueKey('quiz.option.C')));
    await tester.pumpAndSettle();

    expect(find.text('Not quite'), findsOneWidget);
    expect(
      tester.getSemantics(find.byKey(const ValueKey('quiz.option.C'))),
      isSemantics(
        label: 'Option C. Never — a warrant is always required. '
            'Your answer, wrong',
      ),
    );
    expect(
      tester.getSemantics(find.byKey(const ValueKey('quiz.option.B'))),
      isSemantics(
        label: 'Option B. For any cognizable offence, with reasons recorded. '
            'Correct answer',
      ),
    );
  });

  testWidgets('the locked answer ignores further option taps', (
    WidgetTester tester,
  ) async {
    await pumpQuizPage(tester, session: shortSession());

    await tester.tap(find.byKey(const ValueKey('quiz.option.C')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('quiz.option.A')));
    await tester.pumpAndSettle();

    expect(find.text('Not quite'), findsOneWidget);
    expect(
      tester.getSemantics(find.byKey(const ValueKey('quiz.option.C'))),
      isSemantics(
        label: 'Option C. Never — a warrant is always required. '
            'Your answer, wrong',
      ),
    );
  });

  testWidgets('NEXT advances to a fresh question', (
    WidgetTester tester,
  ) async {
    await pumpQuizPage(tester, session: shortSession());

    await tester.tap(find.byKey(const ValueKey('quiz.option.B')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('quiz.next')));
    await tester.pumpAndSettle();

    expect(find.text('Question 2 of 2'), findsOneWidget);
    expect(
      find.textContaining('What is the report you file called'),
      findsOneWidget,
    );
    expect(find.text('SELECT AN ANSWER'), findsOneWidget);
    expect(find.byKey(const ValueKey('quiz.explanation')), findsNothing);
  });

  testWidgets('finishing the last question reports the ordered outcomes', (
    WidgetTester tester,
  ) async {
    List<QuizOutcome>? reported;
    await pumpQuizPage(
      tester,
      session: shortSession(),
      onQuizCompleted: (outcomes) => reported = outcomes,
    );

    await tester.tap(find.byKey(const ValueKey('quiz.option.B')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('quiz.next')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('quiz.option.A')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('quiz.next')));
    await tester.pumpAndSettle();

    expect(reported, isNotNull);
    expect(reported, hasLength(2));
    expect(reported![0].questionId, 'warrantless-arrest');
    expect(reported![0].isCorrect, isTrue);
    expect(reported![1].questionId, 'fir-meaning');
    expect(reported![1].chosenOption, 0);
    expect(reported![1].isCorrect, isFalse);
  });

  testWidgets('the X exits the quiz', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => QuizQuestionPage(onQuizCompleted: (_) {}),
              ),
            ),
            child: const Text('open'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('quiz.exit')), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('quiz.exit')));
    await tester.pumpAndSettle();

    expect(find.text('open'), findsOneWidget);
    expect(find.byKey(const ValueKey('quiz.exit')), findsNothing);
  });
}
