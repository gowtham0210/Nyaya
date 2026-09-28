import '../../../core/presentation/load_state_notifier.dart';
import '../data/legal_updates_repository.dart';

export '../data/legal_updates_repository.dart' show LegalUpdate;

/// Legal updates for Home's section and the see-all list, which share one
/// instance so opening the list doesn't reload (spec 020).
class LegalUpdatesViewModel extends LoadStateNotifier<List<LegalUpdate>> {
  LegalUpdatesViewModel({required LegalUpdatesRepository repository})
    : _repository = repository;

  final LegalUpdatesRepository _repository;

  String get featureId => '020-legal-updates';

  @override
  Future<List<LegalUpdate>> fetch() => _repository.fetchUpdates();

  @override
  bool isEmpty(List<LegalUpdate> updates) => updates.isEmpty;
}
