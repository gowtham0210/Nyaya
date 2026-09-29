import '../../../app/app_session.dart';
import '../../../app/quiz_history_store.dart';
import '../../../app/user_stats_store.dart';
import '../../goal_selection/presentation/goal_selection_view_model.dart';
import '../../leaderboard/presentation/leaderboard_view_model.dart';

/// Read model for the Profile page: the signed-in user's details, their
/// chosen learning goal, and stats derived from their quiz history.
///
/// Defaults to the live [AppSession] / [QuizHistoryStore] singletons but
/// accepts overrides so tests don't need real `SharedPreferences` state.
class ProfileViewModel {
  ProfileViewModel({
    String? fullName,
    String? email,
    String? goalId,
    List<QuizAttempt>? attempts,
    DateTime? memberSince,
    bool memberSinceProvided = false,
    UserStats? stats,
  }) : fullName = _cleanName(fullName ?? AppSession.fullName),
       email = (email ?? AppSession.email ?? '').trim(),
       goalId = goalId ?? AppSession.selectedGoalId,
       // Server-side history wins when there is any: it survives a
       // reinstall and covers every device, unlike the local copy.
       attempts =
           attempts ?? stats?.completedAttempts ?? QuizHistoryStore.attempts,
       memberSince = memberSinceProvided
           ? memberSince
           : (memberSince ?? AppSession.memberSince),
       _stats = stats;

  final UserStats? _stats;

  /// The backend snapshot behind this model, so a caller rebuilding it after
  /// a local edit can carry the live stats over instead of dropping back to
  /// device-only numbers.
  UserStats? get stats => _stats;

  /// True when the stats came from the backend rather than this device's
  /// stored history.
  bool get isLive => _stats != null;

  /// Total points earned, or null when only local history is available —
  /// points are only ever awarded server-side.
  int? get totalPoints => _stats?.progress.totalPoints;

  /// Consecutive days with activity, or null without backend stats.
  int? get currentStreak => _stats?.streak.currentStreak;

  static String _cleanName(String? raw) {
    final trimmed = raw?.trim() ?? '';
    return trimmed.isEmpty ? 'Guest User' : trimmed;
  }

  final String fullName;
  final String email;
  final String? goalId;
  final List<QuizAttempt> attempts;
  final DateTime? memberSince;

  static const _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  /// e.g. "Member since Sep 2026", or null if unknown.
  String? get memberSinceLabel {
    final joined = memberSince;
    if (joined == null) {
      return null;
    }
    return 'Member since ${_months[joined.month - 1]} ${joined.year}';
  }

  /// This user's current standing on the Leaderboard (1 = top).
  ///
  /// The server ranks every user; the sample board is only consulted when
  /// there are no backend stats. A user with backend stats who has not
  /// finished a quiz yet is not on the ranking at all, and sits last.
  int get leaderboardRank {
    final stats = _stats;
    if (stats != null) {
      return stats.rank ?? (stats.leaderboard.length + 1);
    }
    final board = LeaderboardViewModel(
      currentUserName: fullName,
      attempts: attempts,
    );
    return board.entries.firstWhere((entry) => entry.isCurrentUser).rank;
  }

  static final List<GoalOption> _goals = GoalSelectionViewModel().goals;

  /// The user's initials for their avatar, e.g. "Priya Sharma" -> "PS".
  String get initials {
    final parts = fullName
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();
    if (parts.isEmpty) {
      return '?';
    }
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }

  GoalOption? get goal {
    final id = goalId;
    if (id == null) {
      return null;
    }
    for (final option in _goals) {
      if (option.id == id) {
        return option;
      }
    }
    return null;
  }

  int get quizzesCompleted =>
      _stats?.progress.quizzesCompleted ?? attempts.length;

  int get questionsAnswered =>
      _stats?.progress.questionsAnswered ??
      attempts.fold(0, (sum, attempt) => sum + attempt.total);

  /// Average score as a rounded percentage (0-100).
  ///
  /// The backend figure is overall accuracy — correct answers over every
  /// question answered. The local fallback averages each attempt's score
  /// instead, which is the best it can do from stored attempt summaries.
  int get averageScorePercent {
    final stats = _stats;
    if (stats != null) {
      return stats.progress.accuracyPercentage.round();
    }
    if (attempts.isEmpty) {
      return 0;
    }
    final totalFraction = attempts.fold<double>(
      0,
      (sum, attempt) => sum + attempt.scoreFraction,
    );
    return ((totalFraction / attempts.length) * 100).round();
  }

  /// Most recent attempts first, capped for the recent-activity list.
  List<QuizAttempt> get recentAttempts => attempts.take(5).toList();
}
