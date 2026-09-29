import '../features/quiz_question/data/quiz_api.dart';
import '../features/quiz_question/presentation/quiz_session_view_model.dart';
import 'app_session.dart';

/// Everything needed to run one quiz, resolved from the backend where
/// possible and from the app's bundled question lists otherwise.
class QuizLaunch {
  const QuizLaunch({
    required this.slug,
    required this.questions,
    required this.title,
    this.grader,
    this.startIndex = 0,
    this.attemptId,
    this.api,
  });

  /// The catalogue slug this launch was resolved from, set whether or not
  /// the backend was reachable.
  final String slug;

  final List<QuizQuestion> questions;
  final String title;

  /// Null for an offline launch, which grades against the bundled answer key.
  final QuizGrader? grader;

  /// Where to start — non-zero only when resuming a half-finished attempt.
  final int startIndex;

  /// The backend attempt this play-through writes to, null when offline.
  final int? attemptId;

  final QuizApi? api;

  bool get isOffline => attemptId == null;

  /// True when this launch picked up a partly answered attempt rather than
  /// starting a fresh one.
  bool get isResumed => startIndex > 0;

  QuizSessionViewModel buildSession({
    void Function(bool isCorrect)? onAnswered,
  }) => QuizSessionViewModel(
    questions: questions,
    grader: grader,
    startIndex: startIndex,
    onAnswered: onAnswered,
  );
}

/// Resolves quizzes to play, preferring the backend and degrading to the
/// bundled question lists.
///
/// The app shipped its content hardcoded before the backend existed, and
/// those lists are still compiled in. They are the fallback whenever the
/// server can't be reached, the user isn't signed in, or the catalogue has
/// no quiz under the requested slug — so a dead server costs the user their
/// score history, not the ability to study.
class QuizCatalog {
  QuizCatalog({QuizApi? api}) : _api = api ?? QuizApi();

  final QuizApi _api;

  /// Prepares [slug] for play.
  ///
  /// When [resume] is set, an attempt the user left half-finished is picked
  /// up where they stopped instead of a new one being started.
  Future<QuizLaunch> prepare({
    required String slug,
    required List<QuizQuestion> fallbackQuestions,
    required String fallbackTitle,
    bool resume = false,
  }) async {
    final offline = QuizLaunch(
      slug: slug,
      questions: fallbackQuestions,
      title: fallbackTitle,
    );

    if (AppSession.accessToken == null) {
      return offline;
    }

    try {
      final quiz = await _api.findQuizBySlug(slug);
      if (quiz == null) {
        return offline;
      }

      final questions = await _api.fetchQuestions(quiz.id);
      if (questions.isEmpty) {
        return offline;
      }

      var startIndex = 0;
      int? attemptId;

      if (resume) {
        final latest = await _api.fetchLatestAttemptFor(quiz.id);
        // An attempt whose questions have all been answered but which was
        // never submitted has nothing left to resume, so it is left alone
        // and a fresh one started.
        if (latest != null &&
            latest.isInProgress &&
            latest.answeredQuestions < questions.length) {
          attemptId = latest.id;
          startIndex = latest.answeredQuestions;
        }
      }

      attemptId ??= (await _api.startAttempt(quiz.id)).id;

      return QuizLaunch(
        slug: slug,
        questions: questions,
        title: quiz.title,
        grader: RemoteQuizGrader(api: _api, attemptId: attemptId),
        startIndex: startIndex,
        attemptId: attemptId,
        api: _api,
      );
    } on Object {
      // Unreachable server, an expired token, a quiz pulled from the
      // catalogue — all of it lands here and falls back to studying offline.
      return offline;
    }
  }

  /// Prepares a cross-category, difficulty-scoped practice quiz.
  ///
  /// There is no bundled offline content for a random cross-category
  /// draw, so — unlike [prepare] — failure here means "nothing to
  /// play" rather than "study the offline copy": the returned
  /// [QuizLaunch] has empty [QuizLaunch.questions] whenever the user
  /// isn't signed in, the server can't be reached, or the difficulty
  /// currently has no questions.
  Future<QuizLaunch> prepareCustom(String difficulty) async {
    const offline = QuizLaunch(
      slug: 'practice',
      questions: [],
      title: 'Practice Quiz',
    );

    if (AppSession.accessToken == null) {
      return offline;
    }

    try {
      final result = await _api.startCustomAttempt(difficulty);

      if (result.questions.isEmpty) {
        return offline;
      }

      return QuizLaunch(
        slug: 'practice-$difficulty',
        questions: result.questions,
        title: 'Practice Quiz',
        grader: RemoteQuizGrader(api: _api, attemptId: result.attempt.id),
        attemptId: result.attempt.id,
        api: _api,
      );
    } on Object {
      return offline;
    }
  }
}
