import 'auth_api_client.dart';
import 'auth_token_store.dart';

/// The single place that calls [AuthApiClient] and keeps [AuthTokenStore]
/// in sync with the result. Signup, Login, Logout and token-refresh should
/// all go through here rather than hitting [AuthApiClient] or
/// [AuthTokenStore] directly, so the "how a session gets saved/cleared"
/// logic exists in exactly one spot.
class AuthRepository {
  AuthRepository({AuthApiClient? apiClient}) : _apiClient = apiClient ?? AuthApiClient();

  final AuthApiClient _apiClient;

  /// Registers the account with the backend using the phone number Firebase
  /// just verified. [firebaseIdToken] should be the token fetched right
  /// after OTP verification succeeds — it's used once here and never
  /// stored.
  Future<AuthUser?> signup({
    required String fullName,
    required String profession,
    required String phone,
    required String password,
    String? firebaseIdToken,
  }) async {
    final session = await _apiClient.signup(
      fullName: fullName,
      profession: profession,
      phone: phone,
      password: password,
      firebaseIdToken: firebaseIdToken,
    );
    _saveSession(session);
    return session.user;
  }

  Future<AuthUser?> login({
    String? email,
    String? phone,
    required String password,
  }) async {
    final session = await _apiClient.login(email: email, phone: phone, password: password);
    _saveSession(session);
    return session.user;
  }

  /// Exchanges the stored refresh token for a new access/refresh pair.
  /// Returns `true` on success. On failure — expired/revoked token, or none
  /// stored — clears the local session and returns `false`, since the
  /// caller has no usable session to keep around at that point.
  Future<bool> refresh() async {
    final refreshToken = AuthTokenStore.refreshToken;
    if (refreshToken == null) {
      return false;
    }
    try {
      final refreshed = await _apiClient.refresh(refreshToken: refreshToken);
      if (refreshed.accessToken == null || refreshed.refreshToken == null) {
        AuthTokenStore.clear();
        return false;
      }
      AuthTokenStore.saveSession(
        accessToken: refreshed.accessToken,
        refreshToken: refreshed.refreshToken,
        refreshTokenExpiresAt: refreshed.refreshTokenExpiresAt,
      );
      return true;
    } on AuthApiException {
      AuthTokenStore.clear();
      return false;
    }
  }

  /// Best-effort server-side revocation of the refresh token, followed by
  /// clearing the local session regardless of whether the server call
  /// succeeded (e.g. it's already expired, or the network is down).
  Future<void> logout() async {
    final refreshToken = AuthTokenStore.refreshToken;
    if (refreshToken != null) {
      try {
        await _apiClient.logout(refreshToken: refreshToken);
      } catch (_) {
        // Ignore — the local session is cleared below either way.
      }
    }
    AuthTokenStore.clear();
  }

  void _saveSession(AuthSession session) {
    AuthTokenStore.saveSession(
      accessToken: session.accessToken,
      refreshToken: session.refreshToken,
      refreshTokenExpiresAt: session.refreshTokenExpiresAt,
    );
  }
}
