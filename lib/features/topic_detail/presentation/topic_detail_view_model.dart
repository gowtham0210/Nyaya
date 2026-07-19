enum TopicDifficulty { easy, medium, hard }

enum QuizStatus { completed, inProgress, notStarted }

class TopicQuiz {
  const TopicQuiz({
    required this.id,
    required this.title,
    required this.questionCount,
    required this.difficulty,
    required this.status,
  });

  final String id;
  final String title;
  final int questionCount;
  final TopicDifficulty difficulty;
  final QuizStatus status;
}

class TopicDetailViewModel {
  String get featureId => '010-topic-detail';

  String get title => 'Arrest, Bail & Police Powers';

  String get subtitle => 'Under BNSS — formerly CrPC';

  int get quizCount => 6;

  TopicDifficulty get difficulty => TopicDifficulty.medium;

  double get progress => 0.33;

  String get description =>
      'What the police can and cannot do — your rights during FIR, arrest, '
      'custody and bail, under the new BNSS code.';

  String get sectionReference =>
      'Sections referenced: BNSS §35–§62 (formerly CrPC §41–§60)';

  bool isBookmarked = false;

  void toggleBookmark() {
    isBookmarked = !isBookmarked;
  }

  String get continueQuizId => _continueTarget.id;

  String get continueLabel =>
      'CONTINUE QUIZ ${quizzes.indexOf(_continueTarget) + 1}';

  TopicQuiz get _continueTarget => quizzes.firstWhere(
        (quiz) => quiz.status == QuizStatus.inProgress,
        orElse: () => quizzes
            .firstWhere((quiz) => quiz.status == QuizStatus.notStarted),
      );

  final List<TopicQuiz> quizzes = const [
    TopicQuiz(
      id: 'fir-basics',
      title: 'FIR Basics',
      questionCount: 10,
      difficulty: TopicDifficulty.easy,
      status: QuizStatus.completed,
    ),
    TopicQuiz(
      id: 'arrest-your-rights',
      title: 'Arrest & Your Rights',
      questionCount: 12,
      difficulty: TopicDifficulty.medium,
      status: QuizStatus.inProgress,
    ),
    TopicQuiz(
      id: 'custody-remand',
      title: 'Custody & Remand',
      questionCount: 10,
      difficulty: TopicDifficulty.medium,
      status: QuizStatus.notStarted,
    ),
    TopicQuiz(
      id: 'bail-when-how',
      title: 'Bail: When & How',
      questionCount: 14,
      difficulty: TopicDifficulty.hard,
      status: QuizStatus.notStarted,
    ),
  ];
}
