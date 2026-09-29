import 'api_client.dart';

/// One row of the backend leaderboard.
class RemoteLeaderboardEntry {
  const RemoteLeaderboardEntry({
    required this.rank,
    required this.userId,
    required this.fullName,
    required this.totalPoints,
  });

  final int rank;
  final int userId;
  final String fullName;
  final int totalPoints;

  static RemoteLeaderboardEntry fromJson(Map<String, Object?> json) =>
      RemoteLeaderboardEntry(
        rank: (json['rank'] as num).toInt(),
        userId: (json['userId'] as num).toInt(),
        fullName: json['fullName'] as String,
        totalPoints: (json['totalPoints'] as num).toInt(),
      );
}

/// The signed-in user's cumulative stats, as the server counts them.
class RemoteProgress {
  const RemoteProgress({
    required this.totalPoints,
    required this.quizzesCompleted,
    required this.questionsAnswered,
    required this.correctAnswers,
    required this.accuracyPercentage,
  });

  final int totalPoints;
  final int quizzesCompleted;
  final int questionsAnswered;
  final int correctAnswers;
  final double accuracyPercentage;

  static RemoteProgress fromJson(Map<String, Object?> json) => RemoteProgress(
    totalPoints: (json['totalPoints'] as num).toInt(),
    quizzesCompleted: (json['totalQuizzesCompleted'] as num).toInt(),
    questionsAnswered: (json['totalQuestionsAnswered'] as num).toInt(),
    correctAnswers: (json['totalCorrectAnswers'] as num).toInt(),
    accuracyPercentage: (json['accuracyPercentage'] as num).toDouble(),
  );
}

/// The signed-in user's day streak.
class RemoteStreak {
  const RemoteStreak({required this.currentStreak, required this.maxStreak});

  final int currentStreak;
  final int maxStreak;

  static RemoteStreak fromJson(Map<String, Object?> json) => RemoteStreak(
    currentStreak: (json['currentStreak'] as num).toInt(),
    maxStreak: (json['maxStreak'] as num).toInt(),
  );
}

/// Reads the signed-in user's standing: their own totals under
/// `/users/me/*`, and where those totals place them under `/leaderboards/*`.
class UserApi {
  UserApi({ApiClient? client}) : _client = client ?? ApiClient();

  final ApiClient _client;

  /// The all-time ranking, highest points first. The backend caps [limit] at
  /// 100 and only includes users who have a progress row — that is, who have
  /// finished at least one quiz.
  Future<List<RemoteLeaderboardEntry>> fetchGlobalLeaderboard({
    int limit = 50,
  }) async {
    final json = await _client.get('/leaderboards/global?limit=$limit');
    final items = json['items'] as List<Object?>;
    return [
      for (final item in items)
        RemoteLeaderboardEntry.fromJson(item as Map<String, Object?>),
    ];
  }

  /// The weekly or monthly ranking — points earned in the trailing 7 or 30
  /// days, same shape as [fetchGlobalLeaderboard]. [period] is `'weekly'`
  /// or `'monthly'`.
  Future<List<RemoteLeaderboardEntry>> fetchPeriodLeaderboard(
    String period, {
    int limit = 50,
  }) async {
    final json = await _client.get('/leaderboards/$period?limit=$limit');
    final items = json['items'] as List<Object?>;
    return [
      for (final item in items)
        RemoteLeaderboardEntry.fromJson(item as Map<String, Object?>),
    ];
  }

  /// Points earned from quizzes in category [categoryId] — ranked the same
  /// way as the other boards, scoped to just that category.
  Future<List<RemoteLeaderboardEntry>> fetchCategoryLeaderboard(
    int categoryId, {
    int limit = 50,
  }) async {
    final json = await _client.get(
      '/leaderboards/category/$categoryId?limit=$limit',
    );
    final items = json['items'] as List<Object?>;
    return [
      for (final item in items)
        RemoteLeaderboardEntry.fromJson(item as Map<String, Object?>),
    ];
  }

  Future<RemoteProgress> fetchProgress() async {
    return RemoteProgress.fromJson(await _client.get('/users/me/progress'));
  }

  Future<RemoteStreak> fetchStreak() async {
    return RemoteStreak.fromJson(await _client.get('/users/me/streak'));
  }

  /// The signed-in user's own id, needed to pick themselves out of the
  /// leaderboard — the rows identify people by id, not by name.
  Future<int> fetchCurrentUserId() async {
    final json = await _client.get('/users/me');
    return (json['id'] as num).toInt();
  }
}
