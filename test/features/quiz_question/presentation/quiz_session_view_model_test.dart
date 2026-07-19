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

  test('next moves to a fresh unanswered question and updates the counter',
      () {
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
}
