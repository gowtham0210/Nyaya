import '../../quiz_question/presentation/quiz_session_view_model.dart';

/// Derives the quiz result summary from the outcomes reported when a session
/// completes. Pure: no side effects, no persistence.
class QuizResultViewModel {
  QuizResultViewModel({
    required this.outcomes,
    this.topicTitle = 'this topic',
  });

  final List<QuizOutcome> outcomes;
  final String topicTitle;

  int get total => outcomes.length;

  int get correctCount => outcomes.where((o) => o.isCorrect).length;

  int get wrongCount => total - correctCount;

  String get scoreLabel => '$correctCount/$total';

  String get percentLabel {
    if (total == 0) {
      return '0%';
    }
    return '${(correctCount / total * 100).round()}%';
  }

  int get weakCount => wrongCount;

  bool get showWeakStrip => weakCount > 0;

  String get headline => 'Well Done!';

  String get subtitle => '$topicTitle — completed';
}
