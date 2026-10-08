import '../../../core/presentation/load_state.dart';
import '../../../core/presentation/load_state_notifier.dart';
import '../data/topic_repository.dart';

export '../data/topic_repository.dart'
    show QuizStatus, TopicDifficulty, TopicQuiz;

/// A topic (backend category) and its quizzes with the learner's progress
/// (spec 038). Replaces the sample BNSS topic from spec 010.
class TopicDetailViewModel extends LoadStateNotifier<List<TopicQuiz>> {
  TopicDetailViewModel({
    required TopicRepository repository,
    required this.categoryId,
    required this.title,
    this.description,
  }) : _repository = repository;

  final TopicRepository _repository;
  final int categoryId;
  final String title;
  final String? description;

  @override
  Future<List<TopicQuiz>> fetch() => _repository.fetchQuizzes(categoryId);

  @override
  bool isEmpty(List<TopicQuiz> data) => data.isEmpty;

  List<TopicQuiz> get quizzes => switch (state) {
    Loaded(:final data) => data,
    _ => const [],
  };

  int get completedCount =>
      quizzes.where((quiz) => quiz.status == QuizStatus.completed).length;

  /// Share of this topic's quizzes completed, 0–1.
  double get progress => quizzes.isEmpty ? 0 : completedCount / quizzes.length;

  /// The topic's typical difficulty: the most common one (medium on a tie).
  TopicDifficulty get difficulty {
    final counts = {for (final d in TopicDifficulty.values) d: 0};
    for (final quiz in quizzes) {
      counts[quiz.difficulty] = counts[quiz.difficulty]! + 1;
    }
    final top = counts.values.fold(0, (a, b) => a > b ? a : b);
    if (counts[TopicDifficulty.medium] == top) return TopicDifficulty.medium;
    return counts.entries.firstWhere((entry) => entry.value == top).key;
  }

  /// The quiz the bottom button opens: an open attempt first, then the
  /// first not started, then (all done) the first one again. Locked
  /// quizzes are skipped; null when every quiz is locked.
  TopicQuiz? get continueTarget {
    final open = quizzes.where((quiz) => !quiz.isLocked);
    return open.where((q) => q.status == QuizStatus.inProgress).firstOrNull ??
        open.where((q) => q.status == QuizStatus.notStarted).firstOrNull ??
        open.firstOrNull;
  }

  /// 1-based position of [continueTarget] in the list.
  int get continueNumber {
    final target = continueTarget;
    return target == null ? 0 : quizzes.indexOf(target) + 1;
  }
}
