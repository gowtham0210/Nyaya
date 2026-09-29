import 'package:shared_preferences/shared_preferences.dart';

import '../features/quiz_question/data/quiz_api.dart';
import 'app_session.dart';

/// What Home's "Continue Learning" card should show.
class ContinueLearningSnapshot {
  const ContinueLearningSnapshot({
    required this.title,
    required this.questionCount,
    required this.progress,
    required this.canResume,
    this.answeredCount = 0,
  });

  final String title;
  final int questionCount;

  /// Questions answered so far in a half-finished attempt. Only meaningful
  /// when [canResume] is true.
  final int answeredCount;

  /// The ring and bar fill, 0.0-1.0. How far through a half-finished attempt
  /// the user is, or the score of their last completed one.
  final double progress;

  /// True when there is a half-finished attempt to pick up, rather than a
  /// finished one to retake.
  final bool canResume;
}

/// Backs Home's "Continue Learning" card.
///
/// The card follows one fixed quiz — the Indian Constitution set. Its state
/// comes from the user's latest attempt on the backend, which is what makes
/// "Resume" resume: a half-finished attempt reports how many questions were
/// answered, and the card offers to carry on from there. The locally
/// persisted score from [recordResult] is the fallback for a signed-out user
/// or an unreachable server.
class QuizProgressStore {
  QuizProgressStore._();

  static const _progressKey = 'progress.continueLearning.score';

  /// The quiz the card tracks, as seeded into the backend catalogue.
  static const continueLearningSlug = 'indian-constitution-quiz';

  static const _fallbackTitle = 'Indian Constitution Quiz';
  static const _fallbackQuestionCount = 15;

  /// Fraction correct (0.0-1.0) from the last attempt completed on this
  /// device, or null if the quiz has never been completed here.
  static double? progress;

  /// The latest state read from the backend, or null when it has not been
  /// reached yet this session.
  static ContinueLearningSnapshot? remote;

  /// What the card should render, backend state preferred.
  static ContinueLearningSnapshot get snapshot =>
      remote ??
      ContinueLearningSnapshot(
        title: _fallbackTitle,
        questionCount: _fallbackQuestionCount,
        progress: progress ?? 0,
        canResume: false,
      );

  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    progress = prefs.getDouble(_progressKey);
  }

  /// Re-reads the card's state from the backend. Silently leaves [remote]
  /// alone if the user is signed out or the server can't be reached — the
  /// card then falls back to the locally stored score.
  static Future<void> refresh({QuizApi? api}) async {
    if (AppSession.accessToken == null) {
      return;
    }

    final client = api ?? QuizApi();
    try {
      final quiz = await client.findQuizBySlug(continueLearningSlug);
      if (quiz == null) {
        return;
      }

      final attempt = await client.fetchLatestAttemptFor(quiz.id);
      if (attempt == null) {
        remote = ContinueLearningSnapshot(
          title: quiz.title,
          questionCount: quiz.totalQuestions,
          progress: 0,
          canResume: false,
        );
        return;
      }

      final resumable =
          attempt.isInProgress &&
          attempt.answeredQuestions < attempt.totalQuestions;
      remote = ContinueLearningSnapshot(
        title: quiz.title,
        questionCount: quiz.totalQuestions,
        // A half-finished attempt shows how far through it is; a finished
        // one shows what it scored.
        progress: resumable ? attempt.answeredFraction : attempt.scoreFraction,
        canResume: resumable,
        answeredCount: attempt.answeredQuestions,
      );
    } on Object {
      // Leaves whatever the card was already showing in place.
    }
  }

  static Future<void> recordResult({
    required int correctCount,
    required int total,
  }) async {
    if (total <= 0) {
      return;
    }
    final fraction = correctCount / total;
    progress = fraction;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_progressKey, fraction);
  }
}
