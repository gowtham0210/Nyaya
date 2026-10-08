import 'package:flutter_test/flutter_test.dart';
import 'package:nyaya/features/topic_detail/data/topic_repository.dart';

import '../../../support/fake_backend.dart';
import '../../../support/quiz_backend.dart';

void main() {
  test(
    'AC-001 quizzes come oldest first with statuses from attempts',
    () async {
      final quizzes = await TopicRepository(
        fakeBackend(quizRoutes()),
      ).fetchQuizzes(3);

      expect(quizzes.map((q) => q.id), [11, 12, 13]);
      expect(quizzes.map((q) => q.status), [
        QuizStatus.completed,
        QuizStatus.inProgress,
        QuizStatus.notStarted,
      ]);
      expect(quizzes.first.title, 'FIR Basics');
      expect(quizzes.first.questionCount, 10);
      expect(quizzes.first.difficulty, TopicDifficulty.easy);
      expect(quizzes.last.difficulty, TopicDifficulty.hard);
    },
  );

  test('AC-001 a submitted attempt wins over an open one', () async {
    final statuses = await TopicRepository(
      fakeBackend(
        quizRoutes(
          attempts: [
            {'id': 2, 'quizId': 11, 'status': 'in_progress'},
            {'id': 1, 'quizId': 11, 'status': 'submitted'},
          ],
        ),
      ),
    ).fetchStatuses();

    expect(statuses, {11: QuizStatus.completed});
  });

  test('AC-001 locked quizzes carry the points they need', () async {
    final quizzes = await TopicRepository(
      fakeBackend(quizRoutes(lockLast: true)),
    ).fetchQuizzes(3);

    expect(quizzes.last.isLocked, isTrue);
    expect(quizzes.last.requiredPoints, 200);
  });

  test('AC-005 the latest attempt names its category', () async {
    final repository = TopicRepository(fakeBackend(quizRoutes()));

    expect(await repository.fetchLatestCategoryId(), 3);
  });

  test('AC-005 no attempts means no category', () async {
    final repository = TopicRepository(fakeBackend(quizRoutes(attempts: [])));

    expect(await repository.fetchLatestCategoryId(), isNull);
  });
}
