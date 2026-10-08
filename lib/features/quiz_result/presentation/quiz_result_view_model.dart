import '../../quiz_question/presentation/quiz_session_view_model.dart';

/// Derives the quiz result summary from the outcomes reported when a session
/// completes. Pure: no side effects, no persistence.
class QuizResultViewModel {
  QuizResultViewModel({required this.outcomes, this.topicTitle});

  final List<QuizOutcome> outcomes;

  /// Null when the topic is unknown; the page then says "this topic".
  final String? topicTitle;

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

  /// Headline band (spec 037): praise only a good score.
  ResultBand get band {
    if (total == 0) return ResultBand.keepGoing;
    final ratio = correctCount / total;
    if (ratio >= 0.7) return ResultBand.excellent;
    if (ratio >= 0.4) return ResultBand.good;
    return ResultBand.keepGoing;
  }

  int get weakCount => wrongCount;

  bool get showWeakStrip => weakCount > 0;
}

/// Score bands for the result headline: >= 70% (the mockup's 9/12 is
/// "Well Done!"), 40–69%, < 40%.
enum ResultBand { excellent, good, keepGoing }
