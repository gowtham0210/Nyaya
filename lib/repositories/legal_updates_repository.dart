import '../models/legal_update.dart';
import '../services/api_exceptions.dart';
import '../services/auth_storage.dart';
import '../services/legal_updates_api_service.dart';

/// The single source of truth for the Articles screen's "Legal Updates"
/// tab, backed entirely by GET /api/v1/legal-updates. Never returns
/// invented data — callers get real updates or a thrown exception.
class LegalUpdatesRepository {
  LegalUpdatesRepository({LegalUpdatesApiService? api, AuthStorage? authStorage})
      : _api = api ?? LegalUpdatesApiService(),
        _authStorage = authStorage ?? AuthStorage();

  final LegalUpdatesApiService _api;
  final AuthStorage _authStorage;

  /// Throws [UnauthenticatedException] if there's no session, or
  /// [ApiException]/[NetworkException] if the request fails.
  Future<List<LegalUpdate>> getUpdates({String? category}) async {
    final token = await _authStorage.readToken();
    if (token == null) {
      throw UnauthenticatedException();
    }
    return _api.fetchAll(token, category: category);
  }
}
