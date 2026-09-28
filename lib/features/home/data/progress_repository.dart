import '../../../core/network/api_client.dart';

/// The learner's quiz progress.
class LearningProgress {
  const LearningProgress({
    required this.quizzesAttempted,
    required this.quizzesCompleted,
    required this.points,
    required this.accuracy,
  });

  final int quizzesAttempted;
  final int quizzesCompleted;
  final int points;

  /// Share of answers that were correct, 0–1.
  final double accuracy;

  /// Share of attempted quizzes that were completed, 0–1.
  double get completion =>
      quizzesAttempted == 0 ? 0 : quizzesCompleted / quizzesAttempted;
}

/// Progress from `GET /users/me/progress`.
class ProgressRepository {
  ProgressRepository(this._client);

  final ApiClient _client;

  Future<LearningProgress> fetchProgress() async {
    final body = await _client.get('/users/me/progress');
    return LearningProgress(
      quizzesAttempted: (body['totalQuizzesAttempted'] as num).toInt(),
      quizzesCompleted: (body['totalQuizzesCompleted'] as num).toInt(),
      points: (body['totalPoints'] as num).toInt(),
      accuracy: ((body['accuracyPercentage'] as num) / 100).clamp(0.0, 1.0),
    );
  }
}
