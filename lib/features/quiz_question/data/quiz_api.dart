import 'dart:convert';

import '../../../app/api_client.dart';
import '../presentation/quiz_session_view_model.dart';

/// One quiz in the backend catalogue.
class RemoteQuiz {
  const RemoteQuiz({
    required this.id,
    required this.slug,
    required this.title,
    required this.totalQuestions,
    this.categoryId,
    this.description,
    this.difficulty,
    this.levelId,
    this.isLocked = false,
    this.requiredPoints,
  });

  final int id;
  final String slug;
  final String title;
  final int totalQuestions;
  final int? categoryId;
  final String? description;

  /// The points level this quiz is gated behind, or null when it is open.
  final int? levelId;

  /// True while the player's points are below [requiredPoints]; the backend
  /// refuses its questions and new attempts until then.
  final bool isLocked;

  /// Points needed to unlock, or null for an ungated quiz.
  final int? requiredPoints;

  /// The admin-set label for the quiz as a whole: 'easy' | 'medium' | 'hard'.
  final String? difficulty;

  static RemoteQuiz fromJson(Map<String, Object?> json) => RemoteQuiz(
    id: (json['id'] as num).toInt(),
    slug: json['slug'] as String,
    title: json['title'] as String,
    totalQuestions: (json['totalQuestions'] as num).toInt(),
    categoryId: (json['categoryId'] as num?)?.toInt(),
    description: json['description'] as String?,
    difficulty: json['difficulty'] as String?,
    levelId: (json['levelId'] as num?)?.toInt(),
    isLocked: json['isLocked'] == true,
    requiredPoints: (json['requiredPoints'] as num?)?.toInt(),
  );
}

/// A question shown for browsing rather than playing: unlike a playable
/// one it carries its own answer, so the card can reveal it on a tap.
class RemoteFlashQuestion {
  const RemoteFlashQuestion({
    required this.id,
    required this.questionText,
    required this.options,
    required this.correctOption,
    required this.quizTitle,
    this.explanation,
  });

  final int id;
  final String questionText;
  final List<String> options;

  /// Index into [options]; -1 if the backend sent no answer key.
  final int correctOption;
  final String quizTitle;
  final QuizExplanation? explanation;

  static RemoteFlashQuestion fromJson(Map<String, Object?> json) {
    final options = (json['options'] as List<Object?>)
        .cast<Map<String, Object?>>();
    return RemoteFlashQuestion(
      id: (json['id'] as num).toInt(),
      questionText: json['questionText'] as String,
      options: [for (final option in options) option['optionText'] as String],
      correctOption: options.indexWhere(
        (option) => option['isCorrect'] == true,
      ),
      quizTitle: json['quizTitle'] as String? ?? '',
      explanation: _explanationOf(json['explanation'] as String?),
    );
  }
}

/// One practice-mode difficulty tier, as configured by an admin.
class PracticeSetting {
  const PracticeSetting({
    required this.difficulty,
    required this.questionCount,
  });

  final String difficulty;
  final int questionCount;

  static PracticeSetting fromJson(Map<String, Object?> json) => PracticeSetting(
    difficulty: json['difficulty'] as String,
    questionCount: (json['questionCount'] as num).toInt(),
  );
}

/// One of the user's attempts at a quiz.
class RemoteAttempt {
  const RemoteAttempt({
    required this.id,
    required this.quizId,
    required this.status,
    required this.totalQuestions,
    required this.answeredQuestions,
    required this.correctAnswers,
    this.submittedAt,
  });

  final int id;
  final int? quizId;
  final String status;
  final int totalQuestions;
  final int answeredQuestions;
  final int correctAnswers;

  /// When the attempt was finished, or null while it is still open.
  final DateTime? submittedAt;

  bool get isInProgress => status == 'in_progress';

  /// How far through the questions this attempt got, 0.0-1.0.
  double get answeredFraction =>
      totalQuestions == 0 ? 0 : answeredQuestions / totalQuestions;

  /// Fraction answered correctly, 0.0-1.0.
  double get scoreFraction =>
      totalQuestions == 0 ? 0 : correctAnswers / totalQuestions;

  static RemoteAttempt fromJson(Map<String, Object?> json) => RemoteAttempt(
    id: (json['id'] as num).toInt(),
    quizId: json['quizId'] == null ? null : (json['quizId'] as num).toInt(),
    status: json['status'] as String,
    totalQuestions: (json['totalQuestions'] as num).toInt(),
    answeredQuestions: (json['answeredQuestions'] as num).toInt(),
    correctAnswers: (json['correctAnswers'] as num).toInt(),
    submittedAt: json['submittedAt'] is String
        ? DateTime.tryParse(json['submittedAt']! as String)
        : null,
  );
}

/// Explanations are stored as a JSON object in one TEXT column; anything
/// else is treated as the body on its own.
QuizExplanation? _explanationOf(String? raw) {
  if (raw == null || raw.isEmpty) {
    return null;
  }
  try {
    final decoded = jsonDecode(raw);
    if (decoded is Map<String, Object?>) {
      return QuizExplanation(
        core: decoded['core'] as String? ?? '',
        reference: decoded['reference'] as String?,
        takeaway: decoded['takeaway'] as String?,
      );
    }
  } on FormatException {
    // Not JSON: fall through and use it as plain text.
  }
  return QuizExplanation(core: raw);
}

/// Reads the quiz catalogue and drives a play-through against the backend.
///
/// Answers are graded server-side: the playable question payload deliberately
/// withholds the answer key, so every pick is posted and the server's ruling
/// comes back with it. That is also what records points, streaks, and
/// achievements, so a locally graded quiz would score nothing.
class QuizApi {
  QuizApi({ApiClient? client}) : _client = client ?? ApiClient();

  final ApiClient _client;

  /// The catalogue, newest first. The page size covers the seeded content
  /// comfortably; the backend caps it at 100.
  Future<List<RemoteQuiz>> fetchQuizzes() async {
    final json = await _client.get('/quizzes?size=100&active=true');
    final items = json['items'] as List<Object?>;
    return items
        .map((item) => RemoteQuiz.fromJson(item as Map<String, Object?>))
        .toList();
  }

  /// A handful of random questions, answers included, for browsing on Home.
  Future<List<RemoteFlashQuestion>> fetchRandomQuestions({
    int limit = 3,
  }) async {
    final json = await _client.get('/quizzes/random-questions?limit=$limit');
    return [
      for (final item in json['items'] as List<Object?>)
        RemoteFlashQuestion.fromJson(item as Map<String, Object?>),
    ];
  }

  /// The gamification levels: the points tiers a player climbs. Used to name
  /// the level a locked quiz is waiting on.
  Future<Map<int, String>> fetchLevelNames() async {
    final json = await _client.get('/levels');
    return {
      for (final item in json['items'] as List<Object?>)
        ((item as Map<String, Object?>)['id'] as num).toInt():
            item['name'] as String,
    };
  }

  /// The difficulty tiers currently enabled for practice mode.
  Future<List<PracticeSetting>> fetchPracticeSettings() async {
    final json = await _client.get('/practice-settings');
    final items = json['items'] as List<Object?>;
    return [
      for (final item in items)
        PracticeSetting.fromJson(item as Map<String, Object?>),
    ];
  }

  /// Starts a cross-category attempt built from questions at [difficulty].
  Future<({RemoteAttempt attempt, List<QuizQuestion> questions})>
  startCustomAttempt(String difficulty) async {
    final json = await _client.post('/quiz-attempts/custom', {
      'difficulty': difficulty,
    });
    final attempt = RemoteAttempt.fromJson(
      json['attempt'] as Map<String, Object?>,
    );
    final items = json['questions'] as List<Object?>;
    final questions = [
      for (final item in items) _parseQuestion(item as Map<String, Object?>),
    ];
    return (attempt: attempt, questions: questions);
  }

  /// The backend category id whose slug is [categorySlug], or null if no
  /// such category exists.
  Future<int?> findCategoryIdBySlug(String categorySlug) async {
    final categories = await _client.get('/categories');
    for (final item in categories['items'] as List<Object?>) {
      final category = item as Map<String, Object?>;
      if (category['slug'] == categorySlug) {
        return (category['id'] as num).toInt();
      }
    }
    return null;
  }

  /// The active quizzes in the category with [categorySlug], in the
  /// backend's order (newest first) — or null if no such category exists.
  Future<List<RemoteQuiz>?> fetchCategoryQuizzes(String categorySlug) async {
    final id = await findCategoryIdBySlug(categorySlug);
    if (id == null) {
      return null;
    }
    final json = await _client.get('/categories/$id/quizzes');
    return [
      for (final quiz in json['items'] as List<Object?>)
        RemoteQuiz.fromJson(quiz as Map<String, Object?>),
    ];
  }

  /// The quiz with [slug], or null if the catalogue has no such quiz.
  Future<RemoteQuiz?> findQuizBySlug(String slug) async {
    final quizzes = await fetchQuizzes();
    for (final quiz in quizzes) {
      if (quiz.slug == slug) {
        return quiz;
      }
    }
    return null;
  }

  /// The quiz's questions in display order, without their answer keys.
  Future<List<QuizQuestion>> fetchQuestions(int quizId) async {
    final json = await _client.get('/quizzes/$quizId/questions');
    final items = json['items'] as List<Object?>;
    return [
      for (final item in items) _parseQuestion(item as Map<String, Object?>),
    ];
  }

  /// The user's attempts, newest first.
  Future<List<RemoteAttempt>> fetchAttempts({int limit = 20}) async {
    final json = await _client.get('/quiz-attempts?size=$limit');
    final items = json['items'] as List<Object?>;
    return [
      for (final item in items)
        RemoteAttempt.fromJson(item as Map<String, Object?>),
    ];
  }

  /// The user's most recent attempt at [quizId], or null if they have none.
  Future<RemoteAttempt?> fetchLatestAttemptFor(int quizId) async {
    // The backend's page-size cap, so an older unfinished attempt is still
    // found to resume. ponytail: history beyond 100 attempts is not scanned.
    final json = await _client.get('/quiz-attempts?size=100');
    final items = json['items'] as List<Object?>;
    for (final item in items) {
      final attempt = RemoteAttempt.fromJson(item as Map<String, Object?>);
      if (attempt.quizId == quizId) {
        return attempt;
      }
    }
    return null;
  }

  Future<RemoteAttempt> startAttempt(int quizId) async {
    final json = await _client.post('/quiz-attempts', {'quizId': quizId});
    return RemoteAttempt.fromJson(json);
  }

  /// Posts one answer and returns the server's ruling on it.
  Future<QuizVerdict> submitAnswer({
    required int attemptId,
    required QuizQuestion question,
    required int optionIndex,
    int? responseTimeMs,
  }) async {
    final optionIds = question.optionIds;
    final questionId = question.remoteId;
    if (optionIds == null || questionId == null) {
      throw const ApiException('This question is not backed by the server.');
    }

    final json = await _client.post('/quiz-attempts/$attemptId/answers', {
      'questionId': questionId,
      'selectedOptionId': optionIds[optionIndex],
      'responseTimeMs': ?responseTimeMs,
    });

    final isCorrect = json['isCorrect'] as bool;
    final correctOptionId = json['correctOptionId'];
    return QuizVerdict(
      isCorrect: isCorrect,
      // The answer endpoint doesn't send `correctOptionId`, and the quiz
      // screen colours options from this index — so a right answer must
      // point at the option just picked, or it is drawn red as a wrong one.
      // A wrong answer can only reveal the right option if the server says
      // which it is; otherwise -1 (unknown).
      correctOption: isCorrect
          ? optionIndex
          : correctOptionId is num
          ? optionIds.indexOf(correctOptionId.toInt())
          : -1,
    );
  }

  /// Finalises the attempt. The response also carries the updated progress,
  /// streak, and any achievements unlocked, which the result screen does not
  /// show yet.
  Future<RemoteAttempt> submitAttempt(int attemptId) async {
    final json = await _client.post(
      '/quiz-attempts/$attemptId/submit',
      const {},
    );
    return RemoteAttempt.fromJson(json['attempt'] as Map<String, Object?>);
  }

  QuizQuestion _parseQuestion(Map<String, Object?> json) {
    final options = (json['options'] as List<Object?>)
        .cast<Map<String, Object?>>();
    return QuizQuestion(
      id: 'q${(json['id'] as num).toInt()}',
      remoteId: (json['id'] as num).toInt(),
      stem: json['questionText'] as String,
      options: [for (final option in options) option['optionText'] as String],
      optionIds: [for (final option in options) (option['id'] as num).toInt()],
      // Unknown until the server grades a pick.
      correctOption: -1,
      explanation: _parseExplanation(json['explanation'] as String?),
    );
  }

  /// The seeder packs the explanation card's three parts into the single
  /// `explanation` TEXT column as a JSON object. Anything that isn't such an
  /// object — a plain sentence typed into the admin API, say — is treated as
  /// the body text on its own.
  QuizExplanation _parseExplanation(String? raw) {
    if (raw == null || raw.isEmpty) {
      return const QuizExplanation(core: '');
    }
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, Object?> && decoded['core'] is String) {
        return QuizExplanation(
          core: decoded['core'] as String,
          reference: decoded['reference'] as String?,
          takeaway: decoded['takeaway'] as String?,
        );
      }
    } on FormatException {
      // Falls through to the plain-text reading below.
    }
    return QuizExplanation(core: raw);
  }
}

/// Grades picks by posting them to the backend, one request per answer.
class RemoteQuizGrader implements QuizGrader {
  RemoteQuizGrader({required this.api, required this.attemptId});

  final QuizApi api;
  final int attemptId;

  final Stopwatch _sinceLastAnswer = Stopwatch()..start();

  @override
  Future<QuizVerdict> grade(QuizQuestion question, int optionIndex) async {
    final verdict = await api.submitAnswer(
      attemptId: attemptId,
      question: question,
      optionIndex: optionIndex,
      responseTimeMs: _sinceLastAnswer.elapsedMilliseconds,
    );
    _sinceLastAnswer
      ..reset()
      ..start();
    return verdict;
  }
}
