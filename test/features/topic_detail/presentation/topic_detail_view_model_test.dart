import 'package:flutter_test/flutter_test.dart';
import 'package:nyaya/features/topic_detail/presentation/topic_detail_view_model.dart';

void main() {
  test('exposes the BNSS sample topic with its ordered quizzes', () {
    final viewModel = TopicDetailViewModel();

    expect(viewModel.featureId, '010-topic-detail');
    expect(viewModel.title, 'Arrest, Bail & Police Powers');
    expect(viewModel.subtitle, 'Under BNSS — formerly CrPC');
    expect(viewModel.quizCount, 6);
    expect(viewModel.difficulty, TopicDifficulty.medium);
    expect(viewModel.progress, 0.33);
    expect(
      viewModel.description,
      'What the police can and cannot do — your rights during FIR, arrest, '
      'custody and bail, under the new BNSS code.',
    );
    expect(
      viewModel.sectionReference,
      'Sections referenced: BNSS §35–§62 (formerly CrPC §41–§60)',
    );

    expect(viewModel.quizzes, hasLength(4));
    expect(viewModel.quizzes.map((quiz) => quiz.title).toList(), const [
      'FIR Basics',
      'Arrest & Your Rights',
      'Custody & Remand',
      'Bail: When & How',
    ]);
    expect(viewModel.quizzes.map((quiz) => quiz.status).toList(), const [
      QuizStatus.completed,
      QuizStatus.inProgress,
      QuizStatus.notStarted,
      QuizStatus.notStarted,
    ]);
    expect(viewModel.quizzes.first.questionCount, 10);
    expect(viewModel.quizzes.first.difficulty, TopicDifficulty.easy);
  });

  test('continue target is the in-progress quiz, labeled by position', () {
    final viewModel = TopicDetailViewModel();

    expect(viewModel.continueQuizId, 'arrest-your-rights');
    expect(viewModel.continueLabel, 'CONTINUE QUIZ 2');
  });

  test('bookmark starts off and toggles', () {
    final viewModel = TopicDetailViewModel();

    expect(viewModel.isBookmarked, isFalse);
    viewModel.toggleBookmark();
    expect(viewModel.isBookmarked, isTrue);
    viewModel.toggleBookmark();
    expect(viewModel.isBookmarked, isFalse);
  });
}
