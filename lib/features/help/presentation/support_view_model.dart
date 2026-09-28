import '../../../core/presentation/load_state_notifier.dart';
import '../data/support_repository.dart';

export '../data/support_repository.dart' show SupportRequest, SupportStatus;

/// Help & Support (spec 031): past requests, and sending a new one.
class SupportViewModel extends LoadStateNotifier<List<SupportRequest>> {
  SupportViewModel({required SupportRepository repository})
    : _repository = repository;

  final SupportRepository _repository;

  @override
  Future<List<SupportRequest>> fetch() => _repository.fetchRequests();

  @override
  bool isEmpty(List<SupportRequest> requests) => requests.isEmpty;

  bool get sending => _sending;
  var _sending = false;

  /// Why the last send failed; null otherwise.
  Object? get sendError => _sendError;
  Object? _sendError;

  /// Sends a request, then refreshes the list; true when sent. [sending]
  /// stays true until the refresh ends, so it can't be sent twice.
  Future<bool> send({required String subject, required String message}) async {
    _sending = true;
    _sendError = null;
    notifyIfActive();
    try {
      await _repository.send(subject: subject.trim(), message: message.trim());
      // A failed refresh shows Retry; the request was still sent.
      await load();
      return true;
    } catch (error) {
      _sendError = error;
      return false;
    } finally {
      _sending = false;
      notifyIfActive();
    }
  }
}
