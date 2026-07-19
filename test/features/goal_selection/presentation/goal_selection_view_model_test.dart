import 'package:flutter_test/flutter_test.dart';
import 'package:nyaya/features/goal_selection/presentation/goal_selection_view_model.dart';

void main() {
  test('exposes the three v1 goals with Learn law for life selected first', () {
    final viewModel = GoalSelectionViewModel();

    expect(viewModel.featureId, '009-goal-selection');
    expect(viewModel.goals, hasLength(3));
    expect(viewModel.goals.map((goal) => goal.id).toList(), const [
      'learn-law-for-life',
      'crack-an-exam',
      'study-law',
    ]);
    expect(viewModel.goals.map((goal) => goal.title).toList(), const [
      'Learn law for life',
      'Crack an exam',
      'Study law',
    ]);
    expect(
      viewModel.goals.map((goal) => goal.description).toList(),
      const [
        'Everyday legal know-how for work, family and your rights',
        'Sharpen exam-style MCQ practice and statute mastery',
        'Master your LLB subjects, concept by concept',
      ],
    );
    expect(viewModel.selectedGoalId, 'learn-law-for-life');
  });

  test('select moves the selection to the tapped goal', () {
    final viewModel = GoalSelectionViewModel();

    viewModel.select('study-law');

    expect(viewModel.selectedGoalId, 'study-law');
  });

  test('select ignores ids that are not one of the three goals', () {
    final viewModel = GoalSelectionViewModel();

    viewModel.select('become-a-judge');

    expect(viewModel.selectedGoalId, 'learn-law-for-life');
  });
}
