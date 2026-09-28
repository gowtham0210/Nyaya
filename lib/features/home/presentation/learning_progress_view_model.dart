import '../../../core/presentation/load_state_notifier.dart';
import '../data/progress_repository.dart';

export '../data/progress_repository.dart' show LearningProgress;

/// Home's Continue Learning card (spec 026). No attempts yet is empty.
class LearningProgressViewModel extends LoadStateNotifier<LearningProgress> {
  LearningProgressViewModel({required ProgressRepository repository})
    : _repository = repository;

  final ProgressRepository _repository;

  @override
  Future<LearningProgress> fetch() => _repository.fetchProgress();

  @override
  bool isEmpty(LearningProgress progress) => progress.quizzesAttempted == 0;
}
