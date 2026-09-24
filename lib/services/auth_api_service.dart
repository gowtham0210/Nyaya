import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import 'api_exceptions.dart';

/// The access/refresh token pair returned by every NYAYA auth endpoint
/// (login, register, refresh) — see nyaya_backend generateTokenPair.
class AuthTokens {
  const AuthTokens({required this.accessToken, required this.refreshToken});

  final String accessToken;
  final String refreshToken;
}

/// Calls the real NYAYA authentication endpoints
/// (nyaya_backend/src/routes/v1/auth.js: POST /auth/login, POST /auth/register,
/// POST /auth/refresh). Every call returns a fresh [AuthTokens] pair — the
/// accessToken is the Bearer token for other requests, the refreshToken lets
/// [AuthStorage] silently renew the session once the access token expires.
class AuthApiService {
  Uri _uri(String path) => Uri.parse('${ApiConfig.baseUrl}$path');

  Map<String, dynamic> _decode(http.Response response) {
    if (response.body.isEmpty) return const {};
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  void _throwIfError(http.Response response, Map<String, dynamic> body) {
    if (response.statusCode >= 200 && response.statusCode < 300) return;
    final message = (body['message'] ?? body['error'] ?? 'Request failed (${response.statusCode})').toString();
    throw ApiException(response.statusCode, message);
  }

  AuthTokens _tokensFrom(Map<String, dynamic> body) {
    return AuthTokens(accessToken: body['accessToken'] as String, refreshToken: body['refreshToken'] as String);
  }

  Future<AuthTokens> login({required String email, required String password}) async {
    try {
      final response = await http
          .post(
            _uri('/auth/login'),
            headers: const {'Content-Type': 'application/json'},
            body: jsonEncode({'email': email, 'password': password}),
          )
          .timeout(const Duration(seconds: 10));
      final body = _decode(response);
      _throwIfError(response, body);
      return _tokensFrom(body);
    } on ApiException {
      rethrow;
    } on SocketException {
      throw NetworkException('Could not reach the NYAYA server.');
    } catch (e) {
      if (e is NetworkException) rethrow;
      throw NetworkException('Could not reach the NYAYA server.');
    }
  }

  Future<AuthTokens> register({required String fullName, required String email, required String password}) async {
    try {
      final response = await http
          .post(
            _uri('/auth/register'),
            headers: const {'Content-Type': 'application/json'},
            body: jsonEncode({'fullName': fullName, 'email': email, 'password': password}),
          )
          .timeout(const Duration(seconds: 10));
      final body = _decode(response);
      _throwIfError(response, body);
      return _tokensFrom(body);
    } on ApiException {
      rethrow;
    } on SocketException {
      throw NetworkException('Could not reach the NYAYA server.');
    } catch (e) {
      if (e is NetworkException) rethrow;
      throw NetworkException('Could not reach the NYAYA server.');
    }
  }

  /// Exchanges a still-valid refresh token for a brand-new token pair.
  /// Throws [ApiException] if the refresh token itself is invalid/expired —
  /// callers should treat that as a full sign-out.
  Future<AuthTokens> refresh(String refreshToken) async {
    try {
      final response = await http
          .post(
            _uri('/auth/refresh'),
            headers: const {'Content-Type': 'application/json'},
            body: jsonEncode({'refreshToken': refreshToken}),
          )
          .timeout(const Duration(seconds: 10));
      final body = _decode(response);
      _throwIfError(response, body);
      if (body['accessToken'] == null) {
        throw ApiException(401, 'Invalid or expired refresh token');
      }
      return _tokensFrom(body);
    } on ApiException {
      rethrow;
    } on SocketException {
      throw NetworkException('Could not reach the NYAYA server.');
    } catch (e) {
      if (e is NetworkException) rethrow;
      throw NetworkException('Could not reach the NYAYA server.');
    }
  }

  /// Revokes the refresh token server-side (POST /auth/logout). Best-effort:
  /// callers clear the local session regardless of the outcome.
  Future<void> logout(String refreshToken) async {
    try {
      await http
          .post(
            _uri('/auth/logout'),
            headers: const {'Content-Type': 'application/json'},
            body: jsonEncode({'refreshToken': refreshToken}),
          )
          .timeout(const Duration(seconds: 10));
    } catch (_) {}
  }
}
