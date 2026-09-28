import 'package:flutter_test/flutter_test.dart';
import 'package:nyaya/features/home/data/progress_repository.dart';

import '../../../support/fake_backend.dart';

void main() {
  test('AC-001 maps the learner progress', () async {
    final repository = ProgressRepository(
      fakeBackend({
        '/users/me/progress': {
          'userId': 7,
          'totalPoints': 240,
          'currentLevelId': null,
          'totalQuizzesAttempted': 8,
          'totalQuizzesCompleted': 6,
          'totalQuestionsAnswered': 60,
          'totalCorrectAnswers': 45,
          'totalWrongAnswers': 15,
          'accuracyPercentage': 75,
          'updatedAt': '2026-09-28T10:00:00.000Z',
        },
      }),
    );

    final progress = await repository.fetchProgress();

    expect(progress.quizzesAttempted, 8);
    expect(progress.quizzesCompleted, 6);
    expect(progress.points, 240);
    expect(progress.accuracy, 0.75);
    expect(progress.completion, 0.75);
  });

  test('AC-001 no attempts has zero completion', () async {
    final repository = ProgressRepository(
      fakeBackend({
        '/users/me/progress': {
          'totalPoints': 0,
          'totalQuizzesAttempted': 0,
          'totalQuizzesCompleted': 0,
          'accuracyPercentage': 0,
        },
      }),
    );

    final progress = await repository.fetchProgress();

    expect(progress.quizzesAttempted, 0);
    expect(progress.completion, 0);
  });
}
