import 'package:flutter/foundation.dart';

import '../../../core/presentation/load_state.dart';
import '../data/legal_updates_repository.dart';

export '../data/legal_updates_repository.dart' show LegalUpdate;

/// Legal updates for Home's section and the see-all list, which share one
/// instance so opening the list doesn't reload (spec 020).
class LegalUpdatesViewModel extends ChangeNotifier {
  LegalUpdatesViewModel({required LegalUpdatesRepository repository})
    : _repository = repository;

  final LegalUpdatesRepository _repository;
  var _disposed = false;
  var _loadId = 0;

  String get featureId => '020-legal-updates';

  LoadState<List<LegalUpdate>> get state => _state;
  LoadState<List<LegalUpdate>> _state = const Loading();

  /// Loads updates. When loads overlap, only the latest one's result is kept.
  Future<void> load() async {
    final loadId = ++_loadId;
    _setState(const Loading());
    final result = await LoadState.run(
      _repository.fetchUpdates,
      isEmpty: (updates) => updates.isEmpty,
    );
    if (loadId == _loadId) {
      _setState(result);
    }
  }

  void _setState(LoadState<List<LegalUpdate>> state) {
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
