import '../../quiz_question/presentation/quiz_session_view_model.dart';

/// Derives the quiz result summary from the outcomes reported when a session
/// completes. Pure: no side effects, no persistence.
class QuizResultViewModel {
  QuizResultViewModel({
    required this.outcomes,
    this.topicTitle = 'this topic',
    String? headline,
    int? total,
    int? correctCount,
  }) : _headlineOverride = headline,
       _totalOverride = total,
       _correctCountOverride = correctCount;

  final List<QuizOutcome> outcomes;
  final String topicTitle;
  final String? _headlineOverride;

  /// Set when the score covers more than the outcomes in hand — resuming a
  /// half-finished attempt answers only the questions that were left, but
  /// the result is for the whole quiz, so the server's totals are passed
  /// through instead.
  final int? _totalOverride;
  final int? _correctCountOverride;

  int get total => _totalOverride ?? outcomes.length;

  int get correctCount =>
      _correctCountOverride ?? outcomes.where((o) => o.isCorrect).length;

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

  String get headline => _headlineOverride ?? 'Well Done!';

  String get subtitle => '$topicTitle — completed';
}
