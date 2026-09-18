import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../features/auth/data/auth_repository.dart';
import '../features/auth/data/auth_token_store.dart';
import '../features/auth/presentation/sign_in_page.dart';
import '../features/goal_selection/presentation/goal_selection_page.dart';
import '../features/home/presentation/home_page.dart';
import '../features/home/presentation/home_view_model.dart';
import '../features/quiz_question/presentation/quiz_question_page.dart';
import '../features/quiz_result/presentation/quiz_result_page.dart';
import '../features/quiz_result/presentation/quiz_result_view_model.dart';
import '../features/topic_detail/presentation/topic_detail_page.dart';
import '../features/topic_detail/presentation/topic_detail_view_model.dart';
import 'app_session.dart';

const _profileNavIndex = 4;

/// The home page with its app-level wiring, shared by the post-sign-up
/// flow and the returning-user path.
Widget buildWiredHomePage(BuildContext context) {
  const viewModel = HomeViewModel();
  return HomePage(
    viewModel: viewModel,
    // Provisional wire until the Topics tab exists.
    onResumePressed: () => Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (topicContext) => TopicDetailPage(
          onQuizSelected: (quizId) => _startQuiz(topicContext, quizId),
          onContinueQuiz: (quizId) => _startQuiz(topicContext, quizId),
        ),
      ),
    ),
    // Temporary: the Profile tab doubles as a Logout action for testing
    // Signup/OTP repeatedly. Replace once a real Profile screen exists.
    onNavigationSelected: (index) {
      if (index == _profileNavIndex) {
        logout(context);
        return;
      }
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text('${viewModel.navigationItems[index].label} coming soon.'),
          ),
        );
    },
  );
}

final _authRepository = AuthRepository();

/// Revokes the backend session (best-effort), signs out of Firebase, clears
/// all locally stored tokens, then sends the user back to the Login page
/// with a fresh navigation stack — handy for repeatedly testing Signup/OTP
/// with different numbers.
Future<void> logout(BuildContext context) async {
  await _authRepository.logout();
  await FirebaseAuth.instance.signOut();
  AuthTokenStore.clear();
  await AppSession.clear();
  if (!context.mounted) return;
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute<void>(builder: (_) => const SignInPage()),
    (route) => false,
  );
}

/// The sample session ignores the quiz id for its questions, but uses it to
/// name the topic on the result screen.
void _startQuiz(BuildContext context, String quizId) {
  final title = _quizTitle(quizId);
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (quizContext) => QuizQuestionPage(
        onQuizCompleted: (outcomes) => Navigator.of(quizContext).pushReplacement(
          MaterialPageRoute<void>(
            builder: (resultContext) => QuizResultPage(
              viewModel: QuizResultViewModel(
                outcomes: outcomes,
                topicTitle: title,
              ),
              // Review answers (Phase 9) lands next; no-op for now.
              onReviewAnswers: () {},
              onBackToTopic: () => Navigator.of(resultContext).pop(),
            ),
          ),
        ),
      ),
    ),
  );
}

String _quizTitle(String quizId) {
  final quizzes = TopicDetailViewModel().quizzes;
  return quizzes
      .firstWhere(
        (quiz) => quiz.id == quizId,
        orElse: () => quizzes.first,
      )
      .title;
}

/// Replaces the sign-up route with goal selection, then home.
void startPostSignUpFlow(BuildContext context) {
  AppSession.saveSignedIn();
  Navigator.of(context).pushReplacement(
    MaterialPageRoute<void>(
      builder: (goalContext) => GoalSelectionPage(
        onContinue: (goalId) {
          AppSession.saveGoal(goalId);
          Navigator.of(goalContext).pushReplacement(
            MaterialPageRoute<void>(
              builder: (homeContext) => buildWiredHomePage(homeContext),
            ),
          );
        },
      ),
    ),
  );
}
