import 'package:flutter_test/flutter_test.dart';
import 'package:nyaya/features/quiz_question/presentation/quiz_session_view_model.dart';

void main() {
  test('the sample session starts unanswered at question 1 of 12', () {
    final session = QuizSessionViewModel();

    expect(session.featureId, '011-quiz-question');
    expect(session.questions, hasLength(12));
    expect(session.counterLabel, 'Question 1 of 12');
    expect(session.progress, closeTo(1 / 12, 0.001));
    expect(session.isAnswered, isFalse);
    expect(session.isComplete, isFalse);

    final ravi = session.questions[3];
    expect(
      ravi.stem,
      'The police stop Ravi at night and want to arrest him without a '
      'warrant. When is this legal under the BNSS?',
    );
    expect(ravi.options, const [
      'Only if a magistrate has signed the order',
      'For any cognizable offence, with reasons recorded',
      'Never — a warrant is always required',
      'Only between sunrise and sunset',
    ]);
    expect(ravi.correctOption, 1);
    expect(ravi.explanation.reference, 'BNSS §35 (formerly CrPC §41)');
    expect(
      ravi.explanation.takeaway,
      'If arrested, you have the right to know the reason in writing.',
    );
  });

  test('the first answer locks; correctness derives from the question', () {
    final session = QuizSessionViewModel();

    session.answer(1);

    expect(session.isAnswered, isTrue);
    expect(session.selectedOption, 1);
    expect(session.isCorrect, isTrue);
  });

  test('a wrong pick is marked wrong and later taps are ignored', () {
    final session = QuizSessionViewModel();

    session.answer(2);
    session.answer(1);

    expect(session.selectedOption, 2);
    expect(session.isCorrect, isFalse);
  });

  test('next moves to a fresh unanswered question and updates the counter', () {
    final session = QuizSessionViewModel();

    session.answer(1);
    session.next();

    expect(session.counterLabel, 'Question 2 of 12');
    expect(session.isAnswered, isFalse);
    expect(session.isComplete, isFalse);
  });

  test('answering the last question and advancing completes the session '
      'with ordered outcomes', () {
    final questions = QuizSessionViewModel().questions.take(2).toList();
    final session = QuizSessionViewModel(questions: questions);

    session.answer(1); // fir-meaning: correct
    session.next();
    session.answer(0); // zero-fir: wrong
    session.next();

    expect(session.isComplete, isTrue);
    expect(session.outcomes, hasLength(2));
    expect(session.outcomes[0].questionId, 'fir-meaning');
    expect(session.outcomes[0].isCorrect, isTrue);
    expect(session.outcomes[1].questionId, 'zero-fir');
    expect(session.outcomes[1].chosenOption, 0);
    expect(session.outcomes[1].isCorrect, isFalse);
  });

  test('next does nothing while the current question is unanswered', () {
    final session = QuizSessionViewModel();

    session.next();

    expect(session.counterLabel, 'Question 1 of 12');
  });

  test('a session can start partway in, for resuming an attempt', () {
    final session = QuizSessionViewModel(startIndex: 3);

    expect(session.counterLabel, 'Question 4 of 12');
    expect(session.isAnswered, isFalse);
  });

  group('graded against a backend', () {
    test('the verdict comes from the grader, not the question', () async {
      // The bundled key says option 1 is right; the grader overrules it,
      // exactly as the server does for a question fetched without its key.
      final session = QuizSessionViewModel(
        grader: _StubGrader(
          const QuizVerdict(isCorrect: true, correctOption: 2),
        ),
      );

      final answering = session.answer(0);
      expect(session.isGrading, isTrue);
      expect(session.isAnswered, isFalse);

      await answering;

      expect(session.isGrading, isFalse);
      expect(session.isAnswered, isTrue);
      expect(session.isCorrect, isTrue);
      expect(session.revealedCorrectOption, 2);
      expect(session.selectedOption, 0);
    });

    test('a failed grade rolls the pick back so it can be retried', () async {
      final grader = _StubGrader(
        const QuizVerdict(isCorrect: true, correctOption: 1),
        failFirst: true,
      );
      final session = QuizSessionViewModel(grader: grader);

      await session.answer(0);

      expect(session.isAnswered, isFalse);
      expect(session.selectedOption, isNull);
      expect(session.gradingError, isNotNull);

      await session.answer(1);

      expect(session.isAnswered, isTrue);
      expect(session.selectedOption, 1);
    });

    test('taps during grading are ignored', () async {
      final grader = _StubGrader(
        const QuizVerdict(isCorrect: false, correctOption: 1),
      );
      final session = QuizSessionViewModel(grader: grader);

      final first = session.answer(0);
      await session.answer(3);
      await first;

      expect(grader.calls, 1);
      expect(session.selectedOption, 0);
    });

    test('advancing clears the previous verdict', () async {
      final session = QuizSessionViewModel(
        grader: _StubGrader(
          const QuizVerdict(isCorrect: true, correctOption: 1),
        ),
      );

      await session.answer(1);
      session.next();

      expect(session.isAnswered, isFalse);
      expect(session.revealedCorrectOption, isNull);
      expect(session.outcomes.single.isCorrect, isTrue);
    });
  });

  test(
    'reports each graded answer so the caller can react to a wrong one',
    () async {
      final graded = <bool>[];
      final session = QuizSessionViewModel(
        questions: const [
          QuizQuestion(
            id: 'q1',
            stem: 'Highest court?',
            options: ['High Court', 'Supreme Court'],
            correctOption: 1,
            explanation: QuizExplanation(core: 'The apex court.'),
          ),
          QuizQuestion(
            id: 'q2',
            stem: 'Supreme law?',
            options: ['The Constitution', 'A by-law'],
            correctOption: 0,
            explanation: QuizExplanation(core: 'The Constitution.'),
          ),
        ],
        onAnswered: graded.add,
      );

      await session.answer(0); // wrong
      session.next();
      await session.answer(0); // right

      expect(graded, [false, true]);
    },
  );
}

/// Stands in for the server, resolving on a later microtask so the grading
/// window is observable.
class _StubGrader implements QuizGrader {
  _StubGrader(this.verdict, {this.failFirst = false});

  final QuizVerdict verdict;
  final bool failFirst;
  int calls = 0;

  @override
  Future<QuizVerdict> grade(QuizQuestion question, int optionIndex) async {
    calls += 1;
    await Future<void>.delayed(Duration.zero);
    if (failFirst && calls == 1) {
      throw Exception('offline');
    }
    return verdict;
  }
}
