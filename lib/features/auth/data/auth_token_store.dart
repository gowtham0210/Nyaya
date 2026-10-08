import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Where [AuthTokenStore] keeps the session between app runs (spec 044).
abstract interface class TokenVault {
  Future<Map<String, String>> readAll();
  Future<void> writeAll(Map<String, String> values);
  Future<void> deleteAll();
}

/// No persistence: the default, so tests never touch the Keychain.
class MemoryTokenVault implements TokenVault {
  final values = <String, String>{};

  @override
  Future<Map<String, String>> readAll() async => {...values};

  @override
  Future<void> writeAll(Map<String, String> values) async =>
      this.values.addAll(values);

  @override
  Future<void> deleteAll() async => values.clear();
}

/// The iOS Keychain / Android Keystore.
class SecureTokenVault implements TokenVault {
  SecureTokenVault([FlutterSecureStorage? storage])
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  @override
  Future<Map<String, String>> readAll() => _storage.readAll();

  @override
  Future<void> writeAll(Map<String, String> values) async {
    for (final MapEntry(:key, :value) in values.entries) {
      await _storage.write(key: key, value: value);
    }
  }

  @override
  Future<void> deleteAll() => _storage.deleteAll();
}

/// Holds the app's auth tokens, persisted through [vault] so the learner
/// stays signed in across restarts (spec 044). Call sites only ever go
/// through this class.
class AuthTokenStore {
  AuthTokenStore._();

  static const _accessKey = 'auth.accessToken';
  static const _refreshKey = 'auth.refreshToken';
  static const _expiresKey = 'auth.refreshTokenExpiresAt';

  /// Set once in `main`; the in-memory default keeps tests off the disk.
  static TokenVault vault = MemoryTokenVault();

  /// The Firebase phone-auth ID token. Only ever needed transiently, to be
  /// sent once to the backend — never persisted, and cleared as soon as
  /// it's been used.
  static String? idToken;

  /// The Nyaya backend's own session, issued by signup/login and rotated by
  /// refresh.
  static String? accessToken;
  static String? refreshToken;
  static DateTime? refreshTokenExpiresAt;

  static bool get hasSession => accessToken != null && refreshToken != null;

  /// Restores the saved session. [signedIn] is the app's own flag: the
  /// Keychain outlives an uninstall, so tokens without it are stale, as
  /// are tokens past their refresh expiry.
  static Future<void> load({required bool signedIn, DateTime? now}) async {
    final saved = await vault.readAll();
    final expiresAt = DateTime.tryParse(saved[_expiresKey] ?? '');
    final expired =
        expiresAt != null && !expiresAt.isAfter(now ?? DateTime.now());
    if (!signedIn || expired || saved[_refreshKey] == null) {
      clear();
      return;
    }
    accessToken = saved[_accessKey];
    refreshToken = saved[_refreshKey];
    refreshTokenExpiresAt = expiresAt;
  }

  static void saveSession({
    required String? accessToken,
    required String? refreshToken,
    DateTime? refreshTokenExpiresAt,
  }) {
    AuthTokenStore.accessToken = accessToken;
    AuthTokenStore.refreshToken = refreshToken;
    AuthTokenStore.refreshTokenExpiresAt = refreshTokenExpiresAt;
    if (accessToken == null || refreshToken == null) {
      vault.deleteAll();
      return;
    }
    vault.writeAll({
      _accessKey: accessToken,
      _refreshKey: refreshToken,
      // Blank, not missing, so a rotation drops an older expiry.
      _expiresKey: refreshTokenExpiresAt?.toIso8601String() ?? '',
    });
  }

  static void clear() {
    idToken = null;
    accessToken = null;
    refreshToken = null;
    refreshTokenExpiresAt = null;
    vault.deleteAll();
  }
}
