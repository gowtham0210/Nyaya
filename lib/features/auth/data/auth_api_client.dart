import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/network/api_config.dart';

/// Thrown for any non-2xx response or transport-level failure. [message] is
/// suitable to show directly to the user — it's either the backend's own
/// `message` field or a friendly fallback for network/timeout issues.
class AuthApiException implements Exception {
  AuthApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}

class AuthUser {
  const AuthUser({
    required this.id,
    required this.fullName,
    this.email,
    this.phone,
    this.profession,
    required this.phoneVerified,
    required this.status,
  });

  final int id;
  final String fullName;
  final String? email;
  final String? phone;
  final String? profession;
  final bool phoneVerified;
  final String status;

  factory AuthUser.fromJson(Map<String, dynamic> json) => AuthUser(
    id: json['id'] as int,
    fullName: json['fullName'] as String? ?? '',
    email: json['email'] as String?,
    phone: json['phone'] as String?,
    profession: json['profession'] as String?,
    phoneVerified: json['phoneVerified'] as bool? ?? false,
    status: json['status'] as String? ?? 'active',
  );
}

/// The full session returned by signup/login: a usable access token plus a
/// refresh token to obtain new ones later.
class AuthSession {
  const AuthSession({
    required this.accessToken,
    required this.refreshToken,
    this.refreshTokenExpiresAt,
    this.user,
  });

  final String accessToken;
  final String refreshToken;
  final DateTime? refreshTokenExpiresAt;
  final AuthUser? user;

  factory AuthSession.fromJson(Map<String, dynamic> json) => AuthSession(
    accessToken: json['accessToken'] as String,
    refreshToken: json['refreshToken'] as String,
    refreshTokenExpiresAt: _parseDate(json['refreshTokenExpiresAt']),
    user: json['user'] is Map<String, dynamic>
        ? AuthUser.fromJson(json['user'] as Map<String, dynamic>)
        : null,
  );
}

/// The result of `/auth/refresh`. Fields are nullable because the backend
/// returns an all-null 200 response when there was no valid refresh token
/// to use (rather than an error).
class RefreshedTokens {
  const RefreshedTokens({
    this.accessToken,
    this.refreshToken,
    this.refreshTokenExpiresAt,
  });

  final String? accessToken;
  final String? refreshToken;
  final DateTime? refreshTokenExpiresAt;

  factory RefreshedTokens.fromJson(Map<String, dynamic> json) =>
      RefreshedTokens(
        accessToken: json['accessToken'] as String?,
        refreshToken: json['refreshToken'] as String?,
        refreshTokenExpiresAt: _parseDate(json['refreshTokenExpiresAt']),
      );
}

DateTime? _parseDate(Object? value) {
  if (value is String) {
    return DateTime.tryParse(value);
  }
  return null;
}

/// Raw HTTP calls to the Nyaya backend's auth endpoints
/// (`$apiV1BaseUrl/auth/...`). Deliberately stateless — it never reads or
/// writes [AuthTokenStore] itself; see `AuthRepository` for that.
class AuthApiClient {
  AuthApiClient({http.Client? httpClient}) : _httpClient = httpClient ?? http.Client();

  final http.Client _httpClient;

  static const _timeout = Duration(seconds: 15);

  Future<AuthSession> signup({
    required String fullName,
    required String profession,
    required String phone,
    required String password,
    String? firebaseIdToken,
  }) async {
    final response = await _post('/auth/signup', {
      'full_name': fullName,
      'profession': profession,
      'phone': phone,
      'password': password,
      'firebase_id_token': ?firebaseIdToken,
    });
    return AuthSession.fromJson(_decode(response));
  }

  Future<AuthSession> login({
    String? email,
    String? phone,
    required String password,
  }) async {
    final response = await _post('/auth/login', {
      'email': ?email,
      'phone': ?phone,
      'password': password,
    });
    return AuthSession.fromJson(_decode(response));
  }

  Future<RefreshedTokens> refresh({required String refreshToken}) async {
    final response = await _post('/auth/refresh', {
      'refreshToken': refreshToken,
    });
    return RefreshedTokens.fromJson(_decode(response));
  }

  Future<void> logout({required String refreshToken}) async {
    await _post('/auth/logout', {'refreshToken': refreshToken});
  }

  Future<http.Response> _post(String path, Map<String, dynamic> body) async {
    final uri = Uri.parse('${ApiConfig.apiV1BaseUrl}$path');
    http.Response response;
    try {
      response = await _httpClient
          .post(
            uri,
            headers: const {'Content-Type': 'application/json'},
            body: jsonEncode(body),
          )
          .timeout(_timeout);
    } on TimeoutException {
      throw AuthApiException('The server took too long to respond. Please try again.');
    } on http.ClientException {
      throw AuthApiException('Network error. Please check your connection and try again.');
    } catch (_) {
      throw AuthApiException('Network error. Please check your connection and try again.');
    }

    if (response.statusCode >= 400) {
      throw AuthApiException(_extractMessage(response), statusCode: response.statusCode);
    }
    return response;
  }

  Map<String, dynamic> _decode(http.Response response) {
    if (response.body.isEmpty) {
      return const {};
    }
    final decoded = jsonDecode(response.body);
    return decoded is Map<String, dynamic> ? decoded : const {};
  }

  String _extractMessage(http.Response response) {
    try {
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic> && decoded['message'] is String) {
        return decoded['message'] as String;
      }
    } catch (_) {
      // Fall through to the generic message below.
    }
    return 'Request failed (${response.statusCode}). Please try again.';
  }
}
