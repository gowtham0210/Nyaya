import 'package:flutter/material.dart';

import '../features/goal_selection/presentation/goal_selection_page.dart';
import 'app_session.dart';
import 'main_shell.dart';

/// Replaces the sign-up route with goal selection, then makes the main
/// shell the only route so back on Home leaves the app.
void startPostSignUpFlow(BuildContext context) {
  AppSession.saveSignedIn();
  Navigator.of(context).pushReplacement(
    MaterialPageRoute<void>(
      builder: (goalContext) => GoalSelectionPage(
        onContinue: (goalId) {
          AppSession.saveGoal(goalId);
          Navigator.of(goalContext).pushAndRemoveUntil(
            MaterialPageRoute<void>(builder: (_) => const MainShell()),
            (route) => false,
          );
        },
      ),
    ),
  );
}
