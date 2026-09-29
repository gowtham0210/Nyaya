import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Locally persisted session: whether the user finished sign-up, which
/// goal they chose, and (once signed in against the real backend) their
/// auth tokens. Non-sensitive fields live in `SharedPreferences`; the JWT
/// access/refresh tokens live in the platform keychain/keystore via
/// `flutter_secure_storage`.
class AppSession {
  AppSession._();

  static const _secureStorage = FlutterSecureStorage();

  static const _signedInKey = 'session.signedIn';
  static const _goalIdKey = 'session.goalId';
  static const _fullNameKey = 'session.fullName';
  static const _emailKey = 'session.email';
  static const _memberSinceKey = 'session.memberSince';
  static const _accessTokenKey = 'session.accessToken';
  static const _refreshTokenKey = 'session.refreshToken';

  static bool signedIn = false;
  static String? selectedGoalId;
  static String? fullName;
  static String? email;
  static DateTime? memberSince;
  static String? accessToken;
  static String? refreshToken;

  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    signedIn = prefs.getBool(_signedInKey) ?? false;
    selectedGoalId = prefs.getString(_goalIdKey);
    fullName = prefs.getString(_fullNameKey);
    email = prefs.getString(_emailKey);
    final memberSinceIso = prefs.getString(_memberSinceKey);
    memberSince = memberSinceIso == null
        ? null
        : DateTime.tryParse(memberSinceIso);
    accessToken = await _readSecure(_accessTokenKey);
    refreshToken = await _readSecure(_refreshTokenKey);
  }

  /// Persists the tokens and profile returned by a successful register or
  /// login call against the backend, and marks the session signed in.
  static Future<void> saveAuthSession({
    required String fullName,
    required String email,
    required String accessToken,
    required String refreshToken,
  }) async {
    signedIn = true;
    AppSession.fullName = fullName;
    AppSession.email = email;
    AppSession.accessToken = accessToken;
    AppSession.refreshToken = refreshToken;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_signedInKey, true);
    await prefs.setString(_fullNameKey, fullName);
    await prefs.setString(_emailKey, email);
    await _writeSecure(_accessTokenKey, accessToken);
    await _writeSecure(_refreshTokenKey, refreshToken);
  }

  /// Replaces just the token pair, after the access token was refreshed.
  static Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    AppSession.accessToken = accessToken;
    AppSession.refreshToken = refreshToken;
    await _writeSecure(_accessTokenKey, accessToken);
    await _writeSecure(_refreshTokenKey, refreshToken);
  }

  /// Drops the tokens and the signed-in flag when the session can no longer
  /// be renewed, while keeping the goal and profile so a user who signs back
  /// in doesn't have to redo onboarding. [isOnboarded] goes false, which
  /// routes the next launch to sign-in.
  static Future<void> clearTokens() async {
    signedIn = false;
    accessToken = null;
    refreshToken = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_signedInKey);
    await _deleteSecure(_accessTokenKey);
    await _deleteSecure(_refreshTokenKey);
  }

  static Future<void> saveSignedIn() async {
    signedIn = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_signedInKey, true);
  }

  static Future<void> saveGoal(String goalId) async {
    selectedGoalId = goalId;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_goalIdKey, goalId);
  }

  static Future<void> saveProfile({
    required String fullName,
    required String email,
  }) async {
    AppSession.fullName = fullName;
    AppSession.email = email;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_fullNameKey, fullName);
    await prefs.setString(_emailKey, email);
  }

  /// Records when the user first joined, if not already recorded. Safe to
  /// call on every sign-up, since it only writes the first time.
  static Future<void> ensureMemberSinceRecorded() async {
    if (memberSince != null) {
      return;
    }
    final now = DateTime.now();
    memberSince = now;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_memberSinceKey, now.toIso8601String());
  }

  static Future<void> clear() async {
    signedIn = false;
    selectedGoalId = null;
    fullName = null;
    email = null;
    memberSince = null;
    accessToken = null;
    refreshToken = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_signedInKey);
    await prefs.remove(_goalIdKey);
    await prefs.remove(_fullNameKey);
    await prefs.remove(_emailKey);
    await prefs.remove(_memberSinceKey);
    await _deleteSecure(_accessTokenKey);
    await _deleteSecure(_refreshTokenKey);
  }

  /// The user lands on home directly when both steps are complete.
  ///
  /// An access token is part of that: every backend call carries one, and a
  /// session stored before the app had real auth — or one whose token was
  /// cleared — has none. Without this check those users would land on Home
  /// and silently study the bundled offline questions forever, with no way
  /// back to the sign-in screen.
  static bool get isOnboarded =>
      signedIn && accessToken != null && selectedGoalId != null;

  static const _secureStorageTimeout = Duration(seconds: 2);

  // These wrap `flutter_secure_storage` calls so they can never block
  // startup or a sign-in/out flow indefinitely. A missing platform
  // channel (e.g. widget tests, which register no native plugins)
  // throws right away and is caught below; some desktop backends
  // instead never complete the call at all, which a bare try/catch
  // can't help with — hence the explicit timeout racing it. On a real
  // device both paths are no-ops and the call behaves like a direct one.
  static Future<String?> _readSecure(String key) async {
    try {
      return await _secureStorage.read(key: key).timeout(_secureStorageTimeout);
    } catch (_) {
      return null;
    }
  }

  static Future<void> _writeSecure(String key, String value) async {
    try {
      await _secureStorage
          .write(key: key, value: value)
          .timeout(_secureStorageTimeout);
    } catch (_) {
      // Ignored — the in-memory value the caller just set still holds
      // for the rest of this process.
    }
  }

  static Future<void> _deleteSecure(String key) async {
    try {
      await _secureStorage.delete(key: key).timeout(_secureStorageTimeout);
    } catch (_) {
      // Ignored — see _writeSecure.
    }
  }
}
