import '../features/quiz_question/data/quiz_api.dart';
import 'app_session.dart';
import 'notifications_store.dart';
import 'quiz_history_store.dart';
import 'user_api.dart';

/// Everything the Leaderboard and Profile screens read from the backend,
/// fetched in one go.
class UserStats {
  const UserStats({
    required this.leaderboard,
    required this.currentUserId,
    required this.progress,
    required this.streak,
    required this.completedAttempts,
  });

  final List<RemoteLeaderboardEntry> leaderboard;

  /// The signed-in user's id, used to highlight their row — the leaderboard
  /// identifies people by id, and two learners can share a name.
  final int currentUserId;

  final RemoteProgress progress;
  final RemoteStreak streak;

  /// The user's finished attempts, newest first, already labelled with the
  /// quiz title. Reuses [QuizAttempt] so the Profile page's activity list
  /// renders server rows and locally stored ones identically.
  final List<QuizAttempt> completedAttempts;

  /// Where the signed-in user sits in the ranking, or null if they are not
  /// on it yet — the backend only lists learners who have finished a quiz.
  int? get rank {
    for (final entry in leaderboard) {
      if (entry.userId == currentUserId) {
        return entry.rank;
      }
    }
    return null;
  }
}

/// Loads [UserStats], and caches the last successful load for the rest of
/// the session.
///
/// Both screens that use it degrade to locally stored history when the load
/// fails, so a signed-out user or an unreachable server still sees their own
/// device's numbers rather than an error.
class UserStatsStore {
  UserStatsStore._();

  /// The most recent successful load, or null if none has succeeded yet.
  static UserStats? latest;

  /// Fetches fresh stats, returning null (and leaving [latest] alone) if the
  /// user is signed out or the server cannot be reached.
  static Future<UserStats?> refresh({
    UserApi? userApi,
    QuizApi? quizApi,
  }) async {
    if (AppSession.accessToken == null) {
      return null;
    }

    final users = userApi ?? UserApi();
    final quizzes = quizApi ?? QuizApi();

    try {
      // Independent reads, so they go out together rather than in sequence.
      final results = await Future.wait([
        users.fetchGlobalLeaderboard(),
        users.fetchCurrentUserId(),
        users.fetchProgress(),
        users.fetchStreak(),
        quizzes.fetchAttempts(),
        quizzes.fetchQuizzes(),
      ]);

      final leaderboard = results[0] as List<RemoteLeaderboardEntry>;
      final currentUserId = results[1] as int;
      final progress = results[2] as RemoteProgress;
      final streak = results[3] as RemoteStreak;
      final attempts = results[4] as List<RemoteAttempt>;
      final catalogue = results[5] as List<RemoteQuiz>;

      final titles = {for (final quiz in catalogue) quiz.id: quiz.title};

      // A milestone is a fresh 5-day multiple the user has not been
      // notified for yet, so re-fetching stats (e.g. reopening the app the
      // same day) doesn't re-notify.
      final previousStreak = latest?.streak.currentStreak ?? 0;
      if (streak.currentStreak > previousStreak &&
          streak.currentStreak % 5 == 0) {
        await NotificationsStore.addStreakMilestoneNotification(
          streak.currentStreak,
        );
      }

      final stats = UserStats(
        leaderboard: leaderboard,
        currentUserId: currentUserId,
        progress: progress,
        streak: streak,
        completedAttempts: [
          for (final attempt in attempts)
            if (attempt.submittedAt != null)
              QuizAttempt(
                topicTitle: titles[attempt.quizId] ?? 'Quiz',
                correctCount: attempt.correctAnswers,
                total: attempt.totalQuestions,
                completedAt: attempt.submittedAt!,
              ),
        ],
      );

      latest = stats;
      return stats;
    } on Object {
      // Callers fall back to whatever they were already showing.
      return null;
    }
  }
}
