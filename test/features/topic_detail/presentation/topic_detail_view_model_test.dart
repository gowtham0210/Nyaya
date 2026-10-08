import 'package:flutter_test/flutter_test.dart';
import 'package:nyaya/core/presentation/load_state.dart';
import 'package:nyaya/features/topic_detail/data/topic_repository.dart';
import 'package:nyaya/features/topic_detail/presentation/topic_detail_view_model.dart';

import '../../../support/fake_backend.dart';
import '../../../support/quiz_backend.dart';

void main() {
  TopicDetailViewModel viewModel(Map<String, Object> routes) =>
      TopicDetailViewModel(
        repository: TopicRepository(fakeBackend(routes)),
        categoryId: 3,
        title: 'Criminal Procedure',
      );

  test('AC-002 progress and continue target come from attempts', () async {
    final topic = viewModel(quizRoutes());
    addTearDown(topic.dispose);
    await topic.load();

    expect(topic.state, isA<Loaded<List<TopicQuiz>>>());
    expect(topic.completedCount, 1);
    expect(topic.progress, closeTo(1 / 3, 0.001));
    expect(topic.continueTarget?.id, 12);
    expect(topic.continueNumber, 2);
  });

  test('AC-002 with nothing started, the first quiz is next', () async {
    final topic = viewModel(quizRoutes(attempts: []));
    addTearDown(topic.dispose);
    await topic.load();

    expect(topic.progress, 0);
    expect(topic.continueTarget?.id, 11);
    expect(topic.continueTarget?.status, QuizStatus.notStarted);
  });

  test('AC-002 all done offers the first quiz again', () async {
    final topic = viewModel(
      quizRoutes(
        attempts: [
          for (final id in [11, 12, 13])
            {'id': id, 'quizId': id, 'status': 'submitted'},
        ],
      ),
    );
    addTearDown(topic.dispose);
    await topic.load();

    expect(topic.progress, 1);
    expect(topic.continueTarget?.id, 11);
    expect(topic.continueTarget?.status, QuizStatus.completed);
  });

  test('AC-002 locked quizzes are never the continue target', () async {
    final topic = viewModel(
      quizRoutes(
        lockLast: true,
        attempts: [
          {'id': 1, 'quizId': 11, 'status': 'submitted'},
          {'id': 2, 'quizId': 12, 'status': 'submitted'},
        ],
      ),
    );
    addTearDown(topic.dispose);
    await topic.load();

    expect(topic.continueTarget?.id, 11);
  });

  test('AC-002 difficulty is the most common, medium on a tie', () async {
    final topic = viewModel(quizRoutes());
    addTearDown(topic.dispose);
    await topic.load();

    expect(topic.difficulty, TopicDifficulty.medium);
  });

  test('AC-002 no quizzes is empty', () async {
    final topic = viewModel(quizRoutes(categoryQuizzes: {'items': []}));
    addTearDown(topic.dispose);
    await topic.load();

    expect(topic.state, isA<Empty<List<TopicQuiz>>>());
    expect(topic.continueTarget, isNull);
  });
}
