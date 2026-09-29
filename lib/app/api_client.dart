import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'app_session.dart';

/// A user-facing error message extracted from the backend's JSON error body
/// (e.g. "Invalid email or password"), or a generic message for
/// network/parsing failures.
class ApiException implements Exception {
  const ApiException(this.message, {this.statusCode});

  final String message;

  /// The HTTP status the server replied with, or null when the request never
  /// got that far (timeout, DNS failure, no route to host).
  final int? statusCode;

  /// True when the request failed before the server answered. Callers that
  /// have an offline fallback — the quiz flow does — switch to it on this.
  bool get isNetworkFailure => statusCode == null;

  /// True when the session's access token is missing, expired, or rejected.
  bool get isUnauthorized => statusCode == 401;

  @override
  String toString() => message;
}

/// Talks to the Nyaya backend over `/api/v1`.
///
/// The API server is the app's only way in. It never opens a database
/// connection of its own: MySQL credentials live solely in the backend's
/// `.env`, and every read and write goes through an authenticated HTTP
/// endpoint that enforces who may see what. Shipping database credentials
/// inside an app binary would hand every installed copy full read/write
/// access to every user's data, since an APK can be unpacked and its
/// constants read straight out.
///
/// Where that server lives is configured at build time rather than
/// hardcoded:
///
/// ```
/// flutter run --dart-define=NYAYA_API_BASE_URL=http://192.168.0.8:5000/api/v1
/// flutter build apk --dart-define=NYAYA_API_BASE_URL=https://api.nyaya.example/api/v1
/// ```
///
/// With nothing defined it falls back to a local dev server, which only
/// works for an emulator or desktop build on the same machine. On the
/// Android emulator `localhost` means the emulator itself, so `10.0.2.2`
/// — its alias for the host — is used instead. A physical phone can reach
/// neither, and needs the host's LAN IP passed as above.
class ApiClient {
  ApiClient({String? baseUrl, http.Client? httpClient})
    : baseUrl = baseUrl ?? defaultBaseUrl,
      _httpClient = httpClient ?? http.Client();

  final String baseUrl;
  final http.Client _httpClient;

  static const _timeout = Duration(seconds: 15);

  /// Set with `--dart-define=NYAYA_API_BASE_URL=...`; empty when unset.
  static const _configuredBaseUrl = String.fromEnvironment(
    'NYAYA_API_BASE_URL',
  );

  static String get defaultBaseUrl {
    if (_configuredBaseUrl.isNotEmpty) {
      // Trailing slashes would double up against the paths below.
      return _configuredBaseUrl.replaceAll(RegExp(r'/+$'), '');
    }
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:5000/api/v1';
    }
    return 'http://localhost:5000/api/v1';
  }

  Future<Map<String, Object?>> get(String path, {bool authenticated = true}) {
    return _send('GET', path, authenticated: authenticated);
  }

  Future<Map<String, Object?>> post(
    String path,
    Map<String, Object?> body, {
    bool authenticated = true,
  }) {
    return _send('POST', path, body: body, authenticated: authenticated);
  }

  /// Shared across instances so that several requests failing at once
  /// trigger one refresh, not one each.
  static Future<bool>? _refreshInFlight;

  /// Trades the stored refresh token for a fresh pair, returning whether the
  /// session survived. Access tokens last an hour and refresh tokens a
  /// month, so without this a user who left the app open — or came back the
  /// next day — would silently drop to the offline fallback for good.
  Future<bool> _refreshSession() {
    return _refreshInFlight ??= _performRefresh().whenComplete(() {
      _refreshInFlight = null;
    });
  }

  Future<bool> _performRefresh() async {
    final refreshToken = AppSession.refreshToken;
    if (refreshToken == null) {
      await AppSession.clearTokens();
      return false;
    }

    try {
      final json = await _send(
        'POST',
        '/auth/refresh',
        body: {'refreshToken': refreshToken},
        authenticated: false,
        allowRefresh: false,
      );

      final newAccess = json['accessToken'];
      final newRefresh = json['refreshToken'];
      // The endpoint answers 200 with nulls when it does not recognise the
      // token, so a successful response is not on its own a live session.
      if (newAccess is! String || newRefresh is! String) {
        await AppSession.clearTokens();
        return false;
      }

      await AppSession.saveTokens(
        accessToken: newAccess,
        refreshToken: newRefresh,
      );
      return true;
    } on ApiException catch (error) {
      // A refused refresh means the session is genuinely over; a network
      // failure just means try again later, so the tokens are kept.
      if (!error.isNetworkFailure) {
        await AppSession.clearTokens();
      }
      return false;
    }
  }

  Future<Map<String, Object?>> _send(
    String method,
    String path, {
    Map<String, Object?>? body,
    required bool authenticated,
    bool allowRefresh = true,
  }) async {
    final headers = {
      'Content-Type': 'application/json',
      if (authenticated && AppSession.accessToken != null)
        'Authorization': 'Bearer ${AppSession.accessToken}',
    };
    final uri = Uri.parse('$baseUrl$path');

    http.Response response;
    try {
      final request = switch (method) {
        'GET' => _httpClient.get(uri, headers: headers),
        _ => _httpClient.post(
          uri,
          headers: headers,
          body: jsonEncode(body ?? const {}),
        ),
      };
      response = await request.timeout(_timeout);
    } catch (_) {
      throw const ApiException(
        "Couldn't reach the server. Check your connection and try again.",
      );
    }

    Map<String, Object?> decoded;
    try {
      decoded = response.body.isEmpty
          ? const {}
          : jsonDecode(response.body) as Map<String, Object?>;
    } on FormatException {
      throw ApiException(
        'Unexpected response from the server.',
        statusCode: response.statusCode,
      );
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return decoded;
    }

    // An expired access token is renewable, so renew it and replay the
    // request once before surfacing the failure.
    if (response.statusCode == 401 &&
        authenticated &&
        allowRefresh &&
        await _refreshSession()) {
      return _send(
        method,
        path,
        body: body,
        authenticated: authenticated,
        allowRefresh: false,
      );
    }

    final message = decoded['message'];
    throw ApiException(
      message is String ? message : 'Something went wrong. Please try again.',
      statusCode: response.statusCode,
    );
  }
}
