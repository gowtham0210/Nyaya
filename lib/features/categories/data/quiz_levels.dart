import '../../quiz_question/data/quiz_api.dart';

/// The backend category holding the level-wise quizzes ("Level 1" …
/// "Level 10"). Each level is an ordinary quiz whose questions the backend
/// has already mixed across legal topics; nothing about a level's content
/// lives in the app.
const levelsCategorySlug = 'legal-awareness-journey';

/// One level of the Legal Learning Journey, with the user's standing on it.
class QuizLevel {
  const QuizLevel({
    required this.number,
    required this.quiz,
    required this.isMilestone,
    required this.isFinal,
    this.latestAttempt,
    this.isCompleted = false,
    this.levelName,
    this.previousLevelNumber,
  });

  final int number;
  final RemoteQuiz quiz;

  /// A level with more questions than the regular ones (Level 5, Level 10).
  final bool isMilestone;

  /// The last level of the journey.
  final bool isFinal;

  /// The user's most recent attempt at this level, if any.
  final RemoteAttempt? latestAttempt;

  /// True once the user has submitted this level at least once.
  final bool isCompleted;

  /// Name of the points tier this level is gated behind ("Apprentice"), when
  /// the backend gates it.
  final String? levelName;

  /// The level before this one, while it is still unfinished — the journey
  /// runs in order, so this level waits for it. Null once that one is done
  /// (and on the first level, which is always open).
  final int? previousLevelNumber;

  /// Waiting on the previous level to be finished.
  bool get needsPreviousLevel => previousLevelNumber != null;

  /// Locked either because the journey has not reached it yet, or because
  /// the backend gates it behind a points level.
  bool get isLocked => needsPreviousLevel || quiz.isLocked;

  /// Why this level is locked: finishing the one before it comes first,
  /// then the backend's points requirement.
  String get unlockHint {
    final previous = previousLevelNumber;
    if (previous != null) {
      return 'Finish Level $previous first.';
    }
    final points = quiz.requiredPoints;
    if (points == null) {
      return 'Locked for now.';
    }
    final tier = levelName == null ? '' : ' ($levelName)';
    return 'Reach $points points$tier to unlock.';
  }

  /// An attempt was left partway through — the level resumes rather than
  /// starting over (and isn't charged again).
  bool get canResume {
    final attempt = latestAttempt;
    return attempt != null &&
        attempt.isInProgress &&
        attempt.answeredQuestions < attempt.totalQuestions;
  }

  /// "Checkpoint Challenge" / "Final Challenge" for milestone levels.
  String? get milestoneLabel => !isMilestone
      ? null
      : isFinal
      ? 'Final Challenge'
      : 'Checkpoint Challenge';

  /// Human label for the backend's difficulty. A mid-journey checkpoint
  /// draws on everything before it, so it reads as mixed.
  String get difficultyLabel {
    if (isMilestone && !isFinal) {
      return 'Mixed Difficulty';
    }
    return switch (quiz.difficulty) {
      'easy' => 'Beginner',
      'medium' => 'Intermediate',
      'hard' => 'Advanced',
      final other? when other.isNotEmpty =>
        other[0].toUpperCase() + other.substring(1),
      _ => 'Mixed Difficulty',
    };
  }
}

/// The level number of [quiz]: from its slug (`…-level-7`) or else its title
/// (`Level 7`); null for a quiz that isn't a level.
int? levelNumberOf(RemoteQuiz quiz) {
  final match =
      RegExp(r'-level-(\d+)$').firstMatch(quiz.slug) ??
      RegExp(
        r'^\s*Level\s+(\d+)\b',
        caseSensitive: false,
      ).firstMatch(quiz.title);
  return match == null ? null : int.parse(match.group(1)!);
}

/// Builds the ordered levels from the category's [quizzes] and the user's
/// [attempts] (newest first). Pure, so the ordering, milestone and progress
/// rules are testable without a server.
List<QuizLevel> buildQuizLevels(
  List<RemoteQuiz> quizzes,
  List<RemoteAttempt> attempts, [
  Map<int, String> levelNames = const {},
]) {
  final numbered = [
    for (final quiz in quizzes)
      if (levelNumberOf(quiz) case final number?) (number: number, quiz: quiz),
  ]..sort((a, b) => a.number.compareTo(b.number));
  if (numbered.isEmpty) {
    return const [];
  }

  // Milestones are whatever levels carry more questions than the regular
  // ones — read from the data, not a hardcoded list of level numbers.
  final regularSize = numbered
      .map((level) => level.quiz.totalQuestions)
      .reduce((a, b) => a < b ? a : b);
  final lastNumber = numbered.last.number;

  // The journey runs in order: a level opens once the one before it has
  // been submitted. The first level is always open.
  return [
    for (final (index, (:number, :quiz)) in numbered.indexed)
      QuizLevel(
        number: number,
        quiz: quiz,
        isMilestone: quiz.totalQuestions > regularSize,
        isFinal: number == lastNumber,
        latestAttempt: attempts
            .where((attempt) => attempt.quizId == quiz.id)
            .firstOrNull,
        isCompleted: _isCompleted(quiz, attempts),
        levelName: quiz.levelId == null ? null : levelNames[quiz.levelId],
        previousLevelNumber: index == 0
            ? null
            : _isCompleted(numbered[index - 1].quiz, attempts)
            ? null
            : numbered[index - 1].number,
      ),
  ];
}

bool _isCompleted(RemoteQuiz quiz, List<RemoteAttempt> attempts) =>
    attempts.any(
      (attempt) => attempt.quizId == quiz.id && attempt.status == 'submitted',
    );

/// Fetches the levels and the user's attempts from the backend. Throws when
/// the backend can't be reached or the user isn't signed in, so the screen
/// can show its error state.
Future<List<QuizLevel>> loadQuizLevels([QuizApi? api]) async {
  final quizApi = api ?? QuizApi();
  final quizzes = await quizApi.fetchCategoryQuizzes(levelsCategorySlug);
  if (quizzes == null || quizzes.isEmpty) {
    return const [];
  }
  // ponytail: only the newest 100 attempts (the backend's page cap) are
  // read; progress from older attempts would need paging.
  final attempts = await quizApi.fetchAttempts(limit: 100);
  // Names the tier a locked level waits on; a failure here only costs the
  // name, so the list still renders.
  var levelNames = const <int, String>{};
  if (quizzes.any((quiz) => quiz.levelId != null)) {
    try {
      levelNames = await quizApi.fetchLevelNames();
    } on Object {
      levelNames = const {};
    }
  }
  return buildQuizLevels(quizzes, attempts, levelNames);
}
