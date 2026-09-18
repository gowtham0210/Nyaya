/// In-memory holder for the app's auth tokens.
///
/// Deliberately not persisted to disk: tokens are sensitive, and keeping
/// them in memory only means the user simply has to sign in again after a
/// full app restart. If a durable "stay signed in" experience is wanted
/// later, swap this for `flutter_secure_storage` — call sites only ever go
/// through this class, so that change stays localized here.
class AuthTokenStore {
  AuthTokenStore._();

  /// The Firebase phone-auth ID token. Only ever needed transiently, to be
  /// sent once as part of the backend Signup call — never persisted, and
  /// cleared as soon as it's been used (see `AuthRepository.signup`).
  static String? idToken;

  /// The Nyaya backend's own session, issued by signup/login and rotated by
  /// refresh.
  static String? accessToken;
  static String? refreshToken;
  static DateTime? refreshTokenExpiresAt;

  static bool get hasSession => accessToken != null && refreshToken != null;

  static void saveSession({
    required String? accessToken,
    required String? refreshToken,
    DateTime? refreshTokenExpiresAt,
  }) {
    AuthTokenStore.accessToken = accessToken;
    AuthTokenStore.refreshToken = refreshToken;
    AuthTokenStore.refreshTokenExpiresAt = refreshTokenExpiresAt;
  }

  static void clear() {
    idToken = null;
    accessToken = null;
    refreshToken = null;
    refreshTokenExpiresAt = null;
  }
}
