import '../../../core/presentation/load_state_notifier.dart';
import '../data/daily_questions_repository.dart';

export '../data/daily_questions_repository.dart' show DailyQuestion;

/// Home's Daily Questions section (spec 018).
class DailyQuestionsViewModel extends LoadStateNotifier<List<DailyQuestion>> {
  DailyQuestionsViewModel({required DailyQuestionsRepository repository})
    : _repository = repository;

  final DailyQuestionsRepository _repository;
  final _revealed = <int>{};

  @override
  Future<List<DailyQuestion>> fetch() => _repository.fetchDailyQuestions();

  @override
  bool isEmpty(List<DailyQuestion> questions) => questions.isEmpty;

  /// Loads new questions with every answer hidden.
  @override
  Future<void> load() {
    _revealed.clear();
    return super.load();
  }

  bool isRevealed(int questionId) => _revealed.contains(questionId);

  /// Shows the question's answer, or hides it if shown.
  void toggleAnswer(int questionId) {
    if (!_revealed.remove(questionId)) {
      _revealed.add(questionId);
    }
    notifyListeners();
  }
}
