enum GoalIconType { scales, trophy, graduationCap }

class GoalOption {
  const GoalOption({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
  });

  final String id;
  final String title;
  final String description;
  final GoalIconType icon;
}

class GoalSelectionViewModel {
  String get featureId => '009-goal-selection';

  final List<GoalOption> goals = const [
    GoalOption(
      id: 'learn-law-for-life',
      title: 'Learn law for life',
      description: 'Everyday legal know-how for work, family and your rights',
      icon: GoalIconType.scales,
    ),
    GoalOption(
      id: 'crack-an-exam',
      title: 'Crack an exam',
      description: 'Sharpen exam-style MCQ practice and statute mastery',
      icon: GoalIconType.trophy,
    ),
    GoalOption(
      id: 'study-law',
      title: 'Study law',
      description: 'Master your LLB subjects, concept by concept',
      icon: GoalIconType.graduationCap,
    ),
  ];

  String selectedGoalId = 'learn-law-for-life';

  void select(String goalId) {
    if (goals.any((goal) => goal.id == goalId)) {
      selectedGoalId = goalId;
    }
  }
}
