import 'package:flutter/material.dart';

import '../features/goal_selection/presentation/goal_selection_page.dart';
import '../features/home/presentation/home_page.dart';
import '../features/home/presentation/home_view_model.dart';

/// Holds the goal chosen during onboarding until a persistence layer exists.
class GoalSession {
  GoalSession._();

  static String? selectedGoalId;
}

/// Replaces the sign-up route with goal selection, then home.
void startPostSignUpFlow(BuildContext context) {
  Navigator.of(context).pushReplacement(
    MaterialPageRoute<void>(
      builder: (goalContext) => GoalSelectionPage(
        onContinue: (goalId) {
          GoalSession.selectedGoalId = goalId;
          Navigator.of(goalContext).pushReplacement(
            MaterialPageRoute<void>(
              builder: (_) => const HomePage(viewModel: HomeViewModel()),
            ),
          );
        },
      ),
    ),
  );
}
