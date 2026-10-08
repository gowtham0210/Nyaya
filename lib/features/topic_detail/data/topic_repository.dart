import '../../../core/network/api_client.dart';

enum TopicDifficulty { easy, medium, hard }

enum QuizStatus { completed, inProgress, notStarted }

/// One quiz in a topic (a backend category), with the learner's status.
class TopicQuiz {
  const TopicQuiz({
    required this.id,
    required this.title,
    required this.questionCount,
    required this.difficulty,
    this.status = QuizStatus.notStarted,
    this.isLocked = false,
    this.requiredPoints,
  });

  final int id;
  final String title;
  final int questionCount;
  final TopicDifficulty difficulty;
  final QuizStatus status;

  /// Locked until the learner has [requiredPoints] (backend levels).
  final bool isLocked;
  final int? requiredPoints;

  TopicQuiz withStatus(QuizStatus status) => TopicQuiz(
    id: id,
    title: title,
    questionCount: questionCount,
    difficulty: difficulty,
    status: status,
    isLocked: isLocked,
    requiredPoints: requiredPoints,
  );
}

/// A topic's quizzes from `GET /categories/:id/quizzes`, with statuses from
/// the learner's attempts (`GET /quiz-attempts`), so the topic page agrees
/// with Home and Profile (spec 038).
class TopicRepository {
  TopicRepository(this._client);

  final ApiClient _client;

  Future<List<TopicQuiz>> fetchQuizzes(int categoryId) async {
    final results = await Future.wait([
      _client.get('/categories/$categoryId/quizzes'),
      fetchStatuses(),
    ]);
    final body = results[0] as Map<String, dynamic>;
    final statuses = results[1] as Map<int, QuizStatus>;
    final quizzes = [
      for (final item in body['items'] as List<dynamic>? ?? const [])
        if (item is Map<String, dynamic>) _quiz(item),
    ]..sort((a, b) => a.id.compareTo(b.id)); // oldest first: "Quiz 1" is stable
    return [
      for (final quiz in quizzes)
        quiz.withStatus(statuses[quiz.id] ?? QuizStatus.notStarted),
    ];
  }

  /// Per quiz: completed once any attempt is submitted, else in progress
  /// while an attempt is open.
  Future<Map<int, QuizStatus>> fetchStatuses() async {
    final body = await _client.get('/quiz-attempts', query: {'size': '100'});
    final statuses = <int, QuizStatus>{};
    for (final item in body['items'] as List<dynamic>? ?? const []) {
      if (item is! Map<String, dynamic>) continue;
      final quizId = (item['quizId'] as num?)?.toInt();
      if (quizId == null) continue;
      if (item['status'] == 'submitted') {
        statuses[quizId] = QuizStatus.completed;
      } else if (item['status'] == 'in_progress') {
        statuses.putIfAbsent(quizId, () => QuizStatus.inProgress);
      }
    }
    return statuses;
  }

  /// The category of the learner's latest attempt, for Home's Continue
  /// card; null when there is none.
  Future<int?> fetchLatestCategoryId() async {
    final body = await _client.get('/quiz-attempts', query: {'size': '1'});
    final items = body['items'] as List<dynamic>? ?? const [];
    final quizId = items.isEmpty
        ? null
        : ((items.first as Map<String, dynamic>)['quizId'] as num?)?.toInt();
    if (quizId == null) return null;
    final quiz = await _client.get('/quizzes/$quizId');
    return (quiz['categoryId'] as num?)?.toInt();
  }

  TopicQuiz _quiz(Map<String, dynamic> json) => TopicQuiz(
    id: (json['id'] as num).toInt(),
    title: json['title'] as String? ?? '',
    questionCount: (json['totalQuestions'] as num?)?.toInt() ?? 0,
    difficulty: switch (json['difficulty']) {
      'easy' => TopicDifficulty.easy,
      'hard' => TopicDifficulty.hard,
      _ => TopicDifficulty.medium,
    },
    isLocked: json['isLocked'] == true,
    requiredPoints: (json['requiredPoints'] as num?)?.toInt(),
  );
}
