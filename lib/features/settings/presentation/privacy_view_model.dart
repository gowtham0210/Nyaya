import '../../../core/presentation/load_state_notifier.dart';
import '../data/security_repository.dart';

/// Privacy & security (spec 030): the active session count, and logging
/// out of every device.
class PrivacyViewModel extends LoadStateNotifier<int> {
  PrivacyViewModel({required SecurityRepository repository})
    : _repository = repository;

  final SecurityRepository _repository;

  @override
  Future<int> fetch() => _repository.fetchActiveSessions();

  /// A count is always shown, even zero.
  @override
  bool isEmpty(int sessions) => false;

  bool get loggingOut => _loggingOut;
  var _loggingOut = false;

  /// Why the last log-out-everywhere failed; null otherwise.
  Object? get logoutError => _logoutError;
  Object? _logoutError;

  /// Ends every session; true on success, when the app should sign out.
  Future<bool> logoutAll() async {
    _loggingOut = true;
    _logoutError = null;
    notifyIfActive();
    try {
      await _repository.logoutAll();
      return true;
    } catch (error) {
      _logoutError = error;
      return false;
    } finally {
      _loggingOut = false;
      notifyIfActive();
    }
  }
}
