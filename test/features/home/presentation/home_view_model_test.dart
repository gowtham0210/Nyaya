import 'package:flutter_test/flutter_test.dart';
import 'package:nyaya/features/home/presentation/home_view_model.dart';

void main() {
  test('AC-008 and AC-009 expose the home dashboard data model', () {
    const viewModel = HomeViewModel();

    expect(viewModel.featureId, '008-home-page');
    // The sample category strip is gone (spec 040).
    expect(viewModel.popularQuizzes, hasLength(3));
    expect(
      viewModel.popularQuizzes.map((quiz) => quiz.title),
      containsAll(const [
        'Fundamental Rights Quiz',
        'Indian Penal Code Quiz',
        'Contract Act Quiz',
      ]),
    );
  });
}
