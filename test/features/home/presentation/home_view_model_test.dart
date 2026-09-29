import 'package:flutter_test/flutter_test.dart';
import 'package:nyaya/app/quiz_progress_store.dart';
import 'package:nyaya/features/home/presentation/home_view_model.dart';

void main() {
  tearDown(() {
    QuizProgressStore.remote = null;
    QuizProgressStore.progress = null;
  });

  test('AC-004 through AC-009 expose the home dashboard data model', () {
    const viewModel = HomeViewModel();

    expect(viewModel.featureId, '008-home-page');
    expect(viewModel.categories, hasLength(11));
    expect(
      viewModel.categories.map((category) => category.label),
      containsAll(const [
        'Constitutional Law',
        'Criminal & Evidence Law',
        'Civil & General Law',
        'Marriage & Family Law',
        'Labor & Industrial Law',
        'Corporate & Commercial Law',
        'Taxation Law',
        'Cyber & Intellectual Property',
        'Property & Real Estate Law',
        'Banking & Financial Law',
        'Environmental Law',
      ]),
    );
    expect(viewModel.continueLearning.title, 'Indian Constitution Quiz');
    expect(viewModel.continueLearning.questionCount, 15);
    // Nothing recorded on this device and no backend reached, so the card
    // sits at zero rather than showing an invented score.
    expect(viewModel.continueLearning.progress, 0);
    expect(viewModel.continueLearning.canResume, isFalse);
    expect(viewModel.popularQuizzes, hasLength(3));
    expect(
      viewModel.popularQuizzes.map((quiz) => quiz.title),
      containsAll(const [
        'Fundamental Rights Quiz',
        'Indian Penal Code Quiz',
        'Contract Act Quiz',
      ]),
    );
    expect(viewModel.navigationItems, hasLength(5));
    expect(viewModel.activeNavigationIndex, 0);
  });

  test('continue learning falls back to the score recorded on this device', () {
    QuizProgressStore.progress = 0.4;

    expect(const HomeViewModel().continueLearning.progress, 0.4);
  });

  test('continue learning prefers the latest attempt from the backend', () {
    QuizProgressStore.progress = 0.4;
    QuizProgressStore.remote = const ContinueLearningSnapshot(
      title: 'Indian Constitution Quiz',
      questionCount: 15,
      progress: 8 / 15,
      canResume: true,
      answeredCount: 8,
    );

    final continueLearning = const HomeViewModel().continueLearning;

    expect(continueLearning.progress, closeTo(8 / 15, 0.001));
    expect(continueLearning.canResume, isTrue);
    expect(continueLearning.answeredCount, 8);
  });
}
