import 'package:flutter_test/flutter_test.dart';
import 'package:nyaya/features/home/presentation/home_view_model.dart';

void main() {
  test('AC-004 through AC-009 expose the home dashboard data model', () {
    const viewModel = HomeViewModel();

    expect(viewModel.featureId, '008-home-page');
    expect(viewModel.categories, hasLength(5));
    expect(
      viewModel.categories.map((category) => category.label),
      containsAll(const [
        'Constitutional Law',
        'Criminal Law',
        'Civil Law',
        'Contract Law',
        'Legal Reasoning',
      ]),
    );
    expect(viewModel.continueLearning.title, 'Indian Constitution Quiz');
    expect(viewModel.continueLearning.progress, 0.65);
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
}
