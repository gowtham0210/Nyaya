import 'package:flutter/foundation.dart';

import '../../../core/presentation/load_state.dart';
import '../data/daily_questions_repository.dart';

export '../data/daily_questions_repository.dart' show DailyQuestion;

/// Home's Daily Questions section (spec 018).
class DailyQuestionsViewModel extends ChangeNotifier {
  DailyQuestionsViewModel({required DailyQuestionsRepository repository})
    : _repository = repository;

  final DailyQuestionsRepository _repository;
  var _disposed = false;
  var _loadId = 0;
  final _revealed = <int>{};

  LoadState<List<DailyQuestion>> get state => _state;
  LoadState<List<DailyQuestion>> _state = const Loading();

  /// Loads new questions. When loads overlap (Retry during a load), only
  /// the latest one's result is kept.
  Future<void> load() async {
    final loadId = ++_loadId;
    _revealed.clear();
    _setState(const Loading());
    final result = await LoadState.run(
      _repository.fetchDailyQuestions,
      isEmpty: (questions) => questions.isEmpty,
    );
    if (loadId == _loadId) {
      _setState(result);
    }
  }

  bool isRevealed(int questionId) => _revealed.contains(questionId);

  /// Shows the question's answer, or hides it if shown.
  void toggleAnswer(int questionId) {
    if (!_revealed.remove(questionId)) {
      _revealed.add(questionId);
    }
    notifyListeners();
  }

  void _setState(LoadState<List<DailyQuestion>> state) {
    if (_disposed) {
      return;
    }
    _state = state;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
