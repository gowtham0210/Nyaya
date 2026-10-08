import 'package:flutter_test/flutter_test.dart';
import 'package:nyaya/features/quiz_question/data/quiz_play_repository.dart';

import '../../../support/fake_backend.dart';
import '../../../support/quiz_backend.dart';

void main() {
  test('AC-004 questions map text, options, ids and explanation', () async {
    final questions = await QuizPlayRepository(
      fakeBackend(quizRoutes()),
    ).fetchQuestions(12);

    expect(questions, hasLength(2));
    expect(questions.first.id, '1');
    expect(questions.first.stem, 'Who files an FIR?');
    expect(questions.first.options, ['Option 101', 'Option 102']);
    expect(questions.first.optionIds, [101, 102]);
    expect(questions.first.correctOption, isNull);
    expect(questions.first.explanation.core, 'Anyone can file one.');
  });

  test('AC-004 start, answer and submit call the attempt endpoints', () async {
    final answers = <String>[];
    final submits = <String>[];
    final repository = QuizPlayRepository(
      fakeBackend(quizRoutes(answers: answers, submits: submits)),
    );

    final attemptId = await repository.startAttempt(12);
    final right = await repository.answer(
      attemptId: attemptId,
      questionId: 1,
      optionId: 102,
    );
    final wrong = await repository.answer(
      attemptId: attemptId,
      questionId: 2,
      optionId: 201,
    );
    await repository.submit(attemptId);

    expect(attemptId, 99);
    expect(right, isTrue);
    expect(wrong, isFalse);
    expect(answers, [
      '{"questionId":1,"selectedOptionId":102}',
      '{"questionId":2,"selectedOptionId":201}',
    ]);
    expect(submits, ['/api/v1/quiz-attempts/99/submit']);
  });
}
