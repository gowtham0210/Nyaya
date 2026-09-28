import '../../../core/network/api_client.dart';

/// Account security: active sign-ins and signing out everywhere.
class SecurityRepository {
  SecurityRepository(this._client);

  final ApiClient _client;

  /// How many sign-ins are active (`GET /users/me/security`).
  Future<int> fetchActiveSessions() async {
    final body = await _client.get('/users/me/security');
    return (body['activeSessions'] as num).toInt();
  }

  /// Ends every session, this one included (`POST /users/me/logout-all`).
  Future<void> logoutAll() => _client.post('/users/me/logout-all');
}
