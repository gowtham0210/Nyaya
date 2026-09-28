import 'goal.dart';

export 'goal.dart';

class GoalSelectionViewModel {
  String get featureId => '009-goal-selection';

  List<Goal> get goals => Goal.values;

  String selectedGoalId = Goal.learnLawForLife.id;

  void select(String goalId) {
    if (goals.any((goal) => goal.id == goalId)) {
      selectedGoalId = goalId;
    }
  }
}
