import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'auth_api_service.dart';

/// Persists the NYAYA backend's access/refresh token pair between app
/// launches, and silently renews the access token via POST /auth/refresh
/// once it's expired (or about to expire) — so a stale session never shows
/// up as a fake "Invalid or expired token" error when it's actually
/// recoverable.
class AuthStorage {
  AuthStorage({AuthApiService? authApi}) : _authApi = authApi ?? AuthApiService();

  static const _accessTokenKey = 'nyaya_access_token';
  static const _refreshTokenKey = 'nyaya_refresh_token';

  final AuthApiService _authApi;

  /// A short safety margin so a token that's about to expire mid-request
  /// gets refreshed proactively instead of failing.
  static const _expiryBuffer = Duration(seconds: 20);

  /// Returns a Bearer-ready access token, refreshing it first if the stored
  /// one has expired or is about to. Returns null if there's no session, or
  /// if the refresh token itself is no longer valid (session truly over).
  Future<String?> readToken() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString(_accessTokenKey);
    if (accessToken == null) return null;

    if (!_isExpiredOrExpiring(accessToken)) {
      return accessToken;
    }

    final refreshToken = prefs.getString(_refreshTokenKey);
    if (refreshToken == null) {
      await clearToken();
      return null;
    }

    try {
      final tokens = await _authApi.refresh(refreshToken);
      await saveTokens(tokens);
      return tokens.accessToken;
    } catch (_) {
      await clearToken();
      return null;
    }
  }

  Future<String?> readRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshTokenKey);
  }

  Future<void> saveTokens(AuthTokens tokens) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, tokens.accessToken);
    await prefs.setString(_refreshTokenKey, tokens.refreshToken);
  }

  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
  }

  bool _isExpiredOrExpiring(String jwt) {
    final expiresAt = _expiryOf(jwt);
    if (expiresAt == null) return true;
    return DateTime.now().isAfter(expiresAt.subtract(_expiryBuffer));
  }

  DateTime? _expiryOf(String jwt) {
    try {
      final parts = jwt.split('.');
      if (parts.length != 3) return null;
      final normalized = base64Url.normalize(parts[1]);
      final payload = jsonDecode(utf8.decode(base64Url.decode(normalized))) as Map<String, dynamic>;
      final exp = payload['exp'];
      if (exp is! int) return null;
      return DateTime.fromMillisecondsSinceEpoch(exp * 1000);
    } catch (_) {
      return null;
    }
  }
}
